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
    
    // Read API key from Info.plist (FOOTBALL_DATA_API_KEY) or environment variable FOOTBALL_DATA_API_KEY
    private var apiKey: String? {
        if let key = Bundle.main.object(forInfoDictionaryKey: "FOOTBALL_DATA_API_KEY") as? String, !key.isEmpty {
            return key
        }
        if let env = ProcessInfo.processInfo.environment["FOOTBALL_DATA_API_KEY"], !env.isEmpty {
            return env
        }
        return nil
    }
    private let baseURL = "https://api.football-data.org/v4"
    
    override init() {
        super.init()
        loadFavorites()
        fetchWorldCupMatches()
        fetchWorldCupStandings()
    }
    
    func fetchWorldCupMatches() {
        isLoading = true
        // Prefer official API if API key is configured
        guard let key = apiKey else {
            // No API key configured — fallback to public data source
            Task {
                await fetchWorldCupJSONFallback()
            }
            self.errorMessage = "Aucune clé API configurée pour football-data.org. Utilisation d'une source publique en fallback."
            self.isLoading = false
            return
        }

        let urlString = "\(baseURL)/competitions/WC/matches?status=SCHEDULED,LIVE,FINISHED"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "URL invalide"
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.setValue(key, forHTTPHeaderField: "X-Auth-Token")

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

    // Fallback: try public World Cup JSON (best-effort decoding)
    private func fetchWorldCupJSONFallback() async {
        guard let url = URL(string: "https://worldcupjson.net/api/v1/matches") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else { return }
            var newMatches: [Match] = []
            var teamIdCounter = -1
            let iso = ISO8601DateFormatter()
            for item in json {
                let id = (item["fifa_id"] as? String) ?? (item["id"] as? String) ?? UUID().uuidString
                let homeName = (item["home_team_country"] as? String) ?? (item["home_team"] as? String) ?? ""
                let awayName = (item["away_team_country"] as? String) ?? (item["away_team"] as? String) ?? ""
                let dateStr = (item["datetime"] as? String) ?? (item["date"] as? String) ?? ""
                let date = iso.date(from: dateStr) ?? Date()
                let statusStr = (item["status"] as? String) ?? "SCHEDULED"
                let status = statusStr.uppercased()
                let homeGoals = (item["home_team_goals"] as? Int) ?? (item["home_team_score"] as? Int) ?? nil
                let awayGoals = (item["away_team_goals"] as? Int) ?? (item["away_team_score"] as? Int) ?? nil
                let stadium = (item["venue"] as? String) ?? (item["stadium"] as? String) ?? ""

                teamIdCounter -= 1
                let homeTeam = Team(id: teamIdCounter, name: homeName, crest: nil, tla: String(homeName.prefix(3)).uppercased())
                teamIdCounter -= 1
                let awayTeam = Team(id: teamIdCounter, name: awayName, crest: nil, tla: String(awayName.prefix(3)).uppercased())

                let score = Score(fullTime: Score.FullTime(home: homeGoals, away: awayGoals), halfTime: nil)
                let match = Match(id: id, homeTeam: homeTeam, awayTeam: awayTeam, utcDate: date, status: status, score: score)
                newMatches.append(match)
            }
            if !newMatches.isEmpty {
                DispatchQueue.main.async {
                    self.matches = newMatches.sorted { $0.utcDate < $1.utcDate }
                    self.errorMessage = nil
                }
            }
        } catch {
            // silent fallback
        }
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
