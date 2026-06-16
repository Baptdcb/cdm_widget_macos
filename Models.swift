import Foundation

// MARK: - Models

struct Match: Identifiable, Codable {
    let id: String
    let homeTeam: Team
    let awayTeam: Team
    let date: Date
    let status: MatchStatus
    let homeScore: Int?
    let awayScore: Int?
    let stadium: String
    
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var isLive: Bool {
        status == .live
    }
    
    var isUpcoming: Bool {
        status == .upcoming
    }
}

struct Team: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let code: String
    let flag: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.id == rhs.id
    }
}

enum MatchStatus: String, Codable {
    case upcoming = "upcoming"
    case live = "live"
    case finished = "finished"
}

struct StandingsGroup: Identifiable, Codable {
    let id: String
    let name: String
    let teams: [StandingTeam]
}

struct StandingTeam: Identifiable, Codable {
    let id: String
    let team: Team
    let played: Int
    let won: Int
    let drawn: Int
    let lost: Int
    let goalsFor: Int
    let goalsAgainst: Int
    
    var points: Int {
        (won * 3) + (drawn * 1)
    }
    
    var goalDifference: Int {
        goalsFor - goalsAgainst
    }
}

// MARK: - Mock Data

let mockTeams = [
    Team(id: "fra", name: "France", code: "FRA", flag: "🇫🇷"),
    Team(id: "ger", name: "Germany", code: "GER", flag: "🇩🇪"),
    Team(id: "esp", name: "Spain", code: "ESP", flag: "🇪🇸"),
    Team(id: "ita", name: "Italy", code: "ITA", flag: "🇮🇹"),
    Team(id: "eng", name: "England", code: "ENG", flag: "🇬🇧"),
    Team(id: "ned", name: "Netherlands", code: "NED", flag: "🇳🇱"),
    Team(id: "bra", name: "Brazil", code: "BRA", flag: "🇧🇷"),
    Team(id: "arg", name: "Argentina", code: "ARG", flag: "🇦🇷"),
]

let mockMatches = [
    Match(
        id: "1",
        homeTeam: mockTeams[0],
        awayTeam: mockTeams[1],
        date: Date().addingTimeInterval(86400),
        status: .upcoming,
        homeScore: nil,
        awayScore: nil,
        stadium: "Stade de France"
    ),
    Match(
        id: "2",
        homeTeam: mockTeams[2],
        awayTeam: mockTeams[3],
        date: Date().addingTimeInterval(172800),
        status: .upcoming,
        homeScore: nil,
        awayScore: nil,
        stadium: "Santiago Bernabéu"
    ),
    Match(
        id: "3",
        homeTeam: mockTeams[4],
        awayTeam: mockTeams[5],
        date: Date(),
        status: .live,
        homeScore: 2,
        awayScore: 1,
        stadium: "Wembley"
    ),
    Match(
        id: "4",
        homeTeam: mockTeams[6],
        awayTeam: mockTeams[7],
        date: Date().addingTimeInterval(-86400),
        status: .finished,
        homeScore: 3,
        awayScore: 2,
        stadium: "Maracanã"
    ),
]

let mockStandings = [
    StandingsGroup(
        id: "group_a",
        name: "Groupe A",
        teams: [
            StandingTeam(id: "1", team: mockTeams[0], played: 2, won: 2, drawn: 0, lost: 0, goalsFor: 5, goalsAgainst: 1),
            StandingTeam(id: "2", team: mockTeams[1], played: 2, won: 1, drawn: 1, lost: 0, goalsFor: 4, goalsAgainst: 2),
            StandingTeam(id: "3", team: mockTeams[2], played: 2, won: 1, drawn: 0, lost: 1, goalsFor: 3, goalsAgainst: 3),
            StandingTeam(id: "4", team: mockTeams[3], played: 2, won: 0, drawn: 0, lost: 2, goalsFor: 1, goalsAgainst: 7),
        ]
    ),
    StandingsGroup(
        id: "group_b",
        name: "Groupe B",
        teams: [
            StandingTeam(id: "5", team: mockTeams[4], played: 2, won: 2, drawn: 0, lost: 0, goalsFor: 4, goalsAgainst: 1),
            StandingTeam(id: "6", team: mockTeams[5], played: 2, won: 1, drawn: 1, lost: 0, goalsFor: 3, goalsAgainst: 2),
            StandingTeam(id: "7", team: mockTeams[6], played: 2, won: 0, drawn: 1, lost: 1, goalsFor: 2, goalsAgainst: 3),
            StandingTeam(id: "8", team: mockTeams[7], played: 2, won: 0, drawn: 1, lost: 1, goalsFor: 1, goalsAgainst: 4),
        ]
    ),
]
