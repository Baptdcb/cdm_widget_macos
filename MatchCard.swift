import SwiftUI

struct MatchCard: View {
    let match: Match
    @ObservedObject var service: MatchService
    
    var statusColor: Color {
        match.isLive ? .red : match.isUpcoming ? .blue : .gray
    }
    
    var statusText: String {
        match.isLive ? "EN DIRECT 🔴" : match.isUpcoming ? "À VENIR" : "TERMINÉ"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                HStack(spacing: 4) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                    Text(statusText)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(match.displayDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Teams and Score
            HStack(spacing: 20) {
                // Home Team
                VStack(spacing: 8) {
                    FlagImage(url: match.homeTeam.flagURL, fallbackCountry: match.homeTeam.name)
                        .frame(height: 40)
                    
                    Text(match.homeTeam.tla ?? match.homeTeam.name)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
                
                // Score
                VStack(spacing: 4) {
                    if let homeScore = match.score.fullTime?.home,
                       let awayScore = match.score.fullTime?.away {
                        Text("\(homeScore) - \(awayScore)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Text("vs")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(minWidth: 60)
                
                // Away Team
                VStack(spacing: 8) {
                    FlagImage(url: match.awayTeam.flagURL, fallbackCountry: match.awayTeam.name)
                        .frame(height: 40)
                    
                    Text(match.awayTeam.tla ?? match.awayTeam.name)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Stadium and Favorite
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text("Stade")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    service.toggleFavorite(teamId: match.homeTeam.id)
                }) {
                    Image(systemName: service.isFavorite(match.homeTeam.id) ? "star.fill" : "star")
                        .foregroundColor(service.isFavorite(match.homeTeam.id) ? .yellow : .gray)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
    }
}

struct FlagImage: View {
    let url: URL?
    let fallbackCountry: String?
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    // Try fallback by country name
                    if let fallback = fallbackCountry, let fallbackURL = FlagImage.flagURL(for: fallback) {
                        AsyncImage(url: fallbackURL) { p in
                            switch p {
                            case .empty:
                                Rectangle().foregroundColor(.gray.opacity(0.3))
                            case .success(let img):
                                img.resizable().scaledToFit()
                            default:
                                Rectangle().foregroundColor(.gray.opacity(0.3))
                            }
                        }
                    } else {
                        Rectangle().foregroundColor(.gray.opacity(0.3))
                    }
                @unknown default:
                    EmptyView()
                }
            }
        } else if let fallback = fallbackCountry, let fallbackURL = FlagImage.flagURL(for: fallback) {
            AsyncImage(url: fallbackURL) { phase in
                switch phase {
                case .empty:
                    Rectangle().foregroundColor(.gray.opacity(0.3))
                case .success(let image):
                    image.resizable().scaledToFit()
                default:
                    Rectangle().foregroundColor(.gray.opacity(0.3))
                }
            }
        } else {
            Rectangle()
                .foregroundColor(.gray.opacity(0.3))
        }
    }
    
    static func flagURL(for countryName: String) -> URL? {
        let slug = countryName
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
            .folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: "'", with: "")
        return URL(string: "https://countryflagsapi.com/png/\(slug)")
    }
}

#Preview {
    ZStack {
        Color.black
        MatchCard(match: {
            let team1 = Team(id: 1, name: "France", crest: nil, tla: "FRA")
            let team2 = Team(id: 2, name: "Germany", crest: nil, tla: "GER")
            return Match(
                id: "1",
                homeTeam: team1,
                awayTeam: team2,
                utcDate: Date(),
                status: "LIVE",
                score: Score(
                    fullTime: Score.FullTime(home: 2, away: 1),
                    halfTime: nil
                )
            )
        }(), service: MatchService())
    }
}
