import WidgetKit
import SwiftUI

struct LiveMatchesWidget: View {
    let matches: [Match]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🔴 Matchs en Direct")
                .font(.headline)
                .fontWeight(.bold)
            
            if matches.isEmpty {
                Text("Aucun match en direct")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                VStack(spacing: 8) {
                    ForEach(matches.prefix(2)) { match in
                        HStack(spacing: 8) {
                            HStack(spacing: 4) {
                                Text(match.homeTeam.flag)
                                    .font(.system(size: 16))
                                Text(match.homeTeam.code)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                            }
                            
                            VStack(spacing: 2) {
                                if let homeScore = match.homeScore, 
                                   let awayScore = match.awayScore {
                                    Text("\(homeScore) - \(awayScore)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                }
                            }
                            
                            HStack(spacing: 4) {
                                Text(match.awayTeam.code)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                Text(match.awayTeam.flag)
                                    .font(.system(size: 16))
                            }
                            
                            Spacer()
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
    LiveMatchesWidget(matches: mockMatches.filter { $0.status == .live })
}
