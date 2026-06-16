import SwiftUI

struct MatchesView: View {
    @ObservedObject var service: MatchService
    @State private var selectedTab = 0
    
    let tabs = ["EN DIRECT", "À VENIR", "TERMINÉS"]
    
    var displayedMatches: [Match] {
        switch selectedTab {
        case 0:
            return service.liveMatches
        case 1:
            return service.upcomingMatches
        case 2:
            return service.finishedMatches
        default:
            return []
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Picker Tabs
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button(action: { selectedTab = index }) {
                        Text(tabs[index])
                            .font(.caption)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .foregroundColor(selectedTab == index ? .white : .secondary)
                            .background(selectedTab == index ? Color.blue : Color.clear)
                            .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            
            // Matches List
            if displayedMatches.isEmpty {
                VStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                    Text("Aucun match")
                        .foregroundColor(.secondary)
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(displayedMatches) { match in
                            MatchCard(
                                match: match,
                                isFavorite: service.isFavorite(match.homeTeam.id) || 
                                           service.isFavorite(match.awayTeam.id),
                                onFavoriteToggle: {
                                    service.toggleFavorite(teamId: match.homeTeam.id)
                                    service.toggleFavorite(teamId: match.awayTeam.id)
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    MatchesView(service: {
        let service = MatchService()
        return service
    }())
}
