import Foundation
import Combine

// MARK: - API Models

struct Match: Identifiable, Codable {
    let id: String
    let homeTeam: Team
    let awayTeam: Team
    let utcDate: Date
    let status: String
    let score: Score
    
    enum CodingKeys: String, CodingKey {
        case id, homeTeam, awayTeam, utcDate, status, score
    }
    
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone.current
        return formatter.string(from: utcDate)
    }
    
    var isLive: Bool {
        status == "LIVE" || status == "IN_PLAY"
    }
    
    var isUpcoming: Bool {
        status == "TIMED" || status == "SCHEDULED"
    }
    
    var isFinished: Bool {
        status == "FINISHED"
    }
}

struct Team: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let crest: String?
    let tla: String?
    
    var flagURL: URL? {
        guard let crest = crest, !crest.isEmpty else { return nil }
        return URL(string: crest)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.id == rhs.id
    }
}

struct Score: Codable {
    let fullTime: FullTime?
    let halfTime: FullTime?
    
    struct FullTime: Codable {
        let home: Int?
        let away: Int?
    }
}

struct Competition: Codable {
    let matches: [Match]
}

struct Standing: Identifiable, Codable {
    let id = UUID()
    let position: Int
    let team: Team
    let playedGames: Int
    let won: Int
    let draw: Int
    let lost: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let goalDifference: Int
    let points: Int
}

struct Standings: Codable {
    let standings: [StandingsGroup]
}

struct StandingsGroup: Codable {
    let stage: String
    let table: [Standing]
}

// MARK: - Match Service

class MatchService: NSObject, ObservableObject {
    @Published var matches: [Match] = []
    @Published var standings: [Standing] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var favoriteTeams: Set<Int> = []
    
    private let apiKey = "8b1b5cd6cf104cd8b0f5c6b95e4d0fc4" // football-data.org free tier
    private let baseURL = "https://api.football-data.org/v4"
    
    override init() {
        super.init()
        loadFavorites()
        fetchWorldCupMatches()
        fetchWorldCupStandings()
    }
    
    func fetchWorldCupMatches() {
        isLoading = true
        let urlString = "\(baseURL)/competitions/WC/matches?status=SCHEDULED,LIVE,FINISHED"
        guard let url = URL(string: urlString) else { 
            self.errorMessage = "URL invalide"
            self.isLoading = false
            return 
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Erreur réseau: \(error.localizedDescription)"
                    self?.isLoading = false
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "Pas de données reçues"
                    self?.isLoading = false
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let competition = try decoder.decode(Competition.self, from: data)
                    self?.matches = competition.matches.sorted { $0.utcDate < $1.utcDate }
                    self?.errorMessage = nil
                    self?.isLoading = false
                } catch {
                    self?.errorMessage = "Erreur décodage des données"
                    self?.isLoading = false
                }
            }
        }.resume()
    }
    
    func fetchWorldCupStandings() {
        let urlString = "\(baseURL)/competitions/WC/standings"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    let standings = try decoder.decode(Standings.self, from: data)
                    self?.standings = standings.standings.first?.table ?? []
                } catch {
                    print("Erreur standings: \(error)")
                }
            }
        }.resume()
    }
    
    func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(Array(favoriteTeams)) {
            UserDefaults.standard.set(encoded, forKey: "favoriteTeams")
        }
    }
    
    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favoriteTeams"),
           let decoded = try? JSONDecoder().decode([Int].self, from: data) {
            favoriteTeams = Set(decoded)
        }
    }
    
    func toggleFavorite(teamId: Int) {
        if favoriteTeams.contains(teamId) {
            favoriteTeams.remove(teamId)
        } else {
            favoriteTeams.insert(teamId)
        }
        saveFavorites()
    }
    
    func isFavorite(_ teamId: Int) -> Bool {
        favoriteTeams.contains(teamId)
    }
    
    var liveMatches: [Match] {
        matches.filter { $0.isLive }
    }
    
    var upcomingMatches: [Match] {
        matches.filter { $0.isUpcoming }.sorted { $0.utcDate < $1.utcDate }
    }
    
    var finishedMatches: [Match] {
        matches.filter { $0.isFinished }.sorted { $0.utcDate > $1.utcDate }
    }
}
