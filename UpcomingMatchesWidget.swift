import WidgetKit
import SwiftUI

struct UpcomingMatchesWidget: View {
    let matches: [Match]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("⚽ Prochains Matchs")
                .font(.headline)
                .fontWeight(.bold)
            
            if matches.isEmpty {
                Text("Aucun match à venir")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                VStack(spacing: 8) {
                    ForEach(matches.prefix(2)) { match in
                        HStack(spacing: 8) {
                            VStack(spacing: 2) {
                                Text("\(match.homeTeam.flag) \(match.homeTeam.code)")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                Text("\(match.awayTeam.flag) \(match.awayTeam.code)")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(match.displayDate)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(match.stadium)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        .padding(8)
                        .background(Color(nsColor: .controlBackgroundColor))
                        .cornerRadius(4)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    UpcomingMatchesWidget(matches: mockMatches.filter { $0.status == .upcoming })
}
