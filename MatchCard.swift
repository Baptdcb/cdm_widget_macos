import SwiftUI

struct MatchCard: View {
    let match: Match
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var statusColor: Color {
        switch match.status {
        case .live:
            return .red
        case .upcoming:
            return .blue
        case .finished:
            return .gray
        }
    }
    
    var statusText: String {
        switch match.status {
        case .live:
            return "EN DIRECT"
        case .upcoming:
            return "À VENIR"
        case .finished:
            return "TERMINÉ"
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Header with date and status
            HStack {
                Text(match.displayDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                    Text(statusText)
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
            }
            
            // Teams and Score
            HStack(spacing: 16) {
                // Home Team
                VStack(alignment: .trailing, spacing: 4) {
                    Text(match.homeTeam.flag)
                        .font(.system(size: 24))
                    Text(match.homeTeam.code)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                // Score
                VStack(alignment: .center, spacing: 4) {
                    if let homeScore = match.homeScore, let awayScore = match.awayScore {
                        Text("\(homeScore) - \(awayScore)")
                            .font(.title2)
                            .fontWeight(.bold)
                    } else {
                        Text("vs")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(minWidth: 50)
                
                // Away Team
                VStack(alignment: .leading, spacing: 4) {
                    Text(match.awayTeam.flag)
                        .font(.system(size: 24))
                    Text(match.awayTeam.code)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                Spacer()
            }
            
            // Stadium and Favorite
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(match.stadium)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(8)
    }
}

#Preview {
    MatchCard(
        match: mockMatches[2],
        isFavorite: false,
        onFavoriteToggle: {}
    )
    .padding()
}
