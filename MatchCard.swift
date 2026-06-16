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
                    FlagImage(url: match.homeTeam.flagURL)
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
                    FlagImage(url: match.awayTeam.flagURL)
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
    @State private var image: UIImage? = nil
    
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
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Rectangle()
                .foregroundColor(.gray.opacity(0.3))
        }
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
