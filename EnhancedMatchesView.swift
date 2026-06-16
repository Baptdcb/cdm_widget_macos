import SwiftUI

struct EnhancedMatchesView: View {
    @ObservedObject var service: MatchService
    @State private var selectedTab = 0

    let tabs = ["EN DIRECT", "À VENIR", "TERMINÉS"]

    var displayedMatches: [Match] {
        switch selectedTab {
        case 0: return service.liveMatches
        case 1: return service.upcomingMatches
        case 2: return service.finishedMatches
        default: return []
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Matchs")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)

            HStack(spacing: 8) {
                ForEach(0..<tabs.count, id: \.self) { idx in
                    Button(action: { selectedTab = idx }) {
                        Text(tabs[idx])
                            .font(.caption).fontWeight(.semibold)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(selectedTab == idx ? Color.accentColor.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .padding(.horizontal)

            if displayedMatches.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "sportscourt")
                        .font(.system(size: 36))
                        .foregroundColor(.secondary)
                    Text("Aucun match")
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(displayedMatches) { match in
                            EnhancedMatchCardCompat(match: match, service: service)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}

#Preview {
    EnhancedMatchesView(service: MatchService())
}
