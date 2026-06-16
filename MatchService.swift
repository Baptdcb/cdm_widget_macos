import Foundation

class MatchService: ObservableObject {
    @Published var matches: [Match] = []
    @Published var standings: [StandingsGroup] = []
    @Published var favoriteTeams: Set<String> = []
    
    init() {
        loadMockData()
        loadFavorites()
    }
    
    func loadMockData() {
        self.matches = mockMatches
        self.standings = mockStandings
    }
    
    func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(Array(favoriteTeams)) {
            UserDefaults.standard.set(encoded, forKey: "favoriteTeams")
        }
    }
    
    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favoriteTeams"),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            favoriteTeams = Set(decoded)
        }
    }
    
    func toggleFavorite(teamId: String) {
        if favoriteTeams.contains(teamId) {
            favoriteTeams.remove(teamId)
        } else {
            favoriteTeams.insert(teamId)
        }
        saveFavorites()
    }
    
    func isFavorite(_ teamId: String) -> Bool {
        favoriteTeams.contains(teamId)
    }
    
    var upcomingMatches: [Match] {
        matches.filter { $0.status == .upcoming }.sorted { $0.date < $1.date }
    }
    
    var liveMatches: [Match] {
        matches.filter { $0.status == .live }
    }
    
    var finishedMatches: [Match] {
        matches.filter { $0.status == .finished }.sorted { $0.date > $1.date }
    }
    
    var favoriteMatches: [Match] {
        matches.filter { match in
            favoriteTeams.contains(match.homeTeam.id) || 
            favoriteTeams.contains(match.awayTeam.id)
        }
    }
}
