import SwiftUI

struct EnhancedMatchCardCompat: View {
    let match: Match
    @ObservedObject var service: MatchService

    private var statusColor: Color {
        match.isLive ? .red : match.isUpcoming ? .blue : .gray
    }

    private var statusText: String {
        match.isLive ? "EN DIRECT" : match.isUpcoming ? "À VENIR" : "TERMINÉ"
    }

    var body: some View {
        HStack(spacing: 12) {
            // Home
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    FlagImage(url: match.homeTeam.flagURL, fallbackCountry: match.homeTeam.name)
                        .frame(width: 48, height: 32)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(match.homeTeam.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text(match.homeTeam.tla ?? "")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()

            VStack(spacing: 4) {
                if let home = match.score.fullTime?.home, let away = match.score.fullTime?.away {
                    Text("\(home) – \(away)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                } else {
                    Text(match.displayDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 6) {
                    Circle().fill(statusColor).frame(width:8,height:8)
                    Text(statusText)
                        .font(.caption2).fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            }
            .frame(minWidth: 120)

            Spacer()

            // Away
            VStack(alignment: .trailing, spacing: 6) {
                HStack(spacing: 8) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(match.awayTeam.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text(match.awayTeam.tla ?? "")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    FlagImage(url: match.awayTeam.flagURL, fallbackCountry: match.awayTeam.name)
                        .frame(width: 48, height: 32)
                }
            }

            Button(action: {
                service.toggleFavorite(teamId: match.homeTeam.id)
            }) {
                Image(systemName: service.isFavorite(match.homeTeam.id) ? "star.fill" : "star")
                    .foregroundColor(service.isFavorite(match.homeTeam.id) ? .yellow : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    EnhancedMatchCardCompat(match: {
        let team1 = Team(id: 1, name: "France", crest: nil, tla: "FRA")
        let team2 = Team(id: 2, name: "Germany", crest: nil, tla: "GER")
        return Match(id: "1", homeTeam: team1, awayTeam: team2, utcDate: Date(), status: "LIVE", score: Score(fullTime: Score.FullTime(home: 2, away: 1), halfTime: nil))
    }(), service: MatchService())
    .padding()
    .frame(width: 700)
}
