import SwiftUI

struct ContentView: View {
    @StateObject private var service = MatchService()
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content
            Group {
                switch selectedTab {
                case 0:
                    MatchesView(service: service)
                case 1:
                    StandingsView(service: service)
                case 2:
                    FavoritesView(service: service)
                default:
                    MatchesView(service: service)
                }
            }
            
            Divider()
            
            // Tab Bar
            HStack(spacing: 0) {
                TabBarItem(
                    icon: "soccer.ball",
                    label: "Matchs",
                    isSelected: selectedTab == 0,
                    action: { selectedTab = 0 }
                )
                TabBarItem(
                    icon: "list.number",
                    label: "Classement",
                    isSelected: selectedTab == 1,
                    action: { selectedTab = 1 }
                )
                TabBarItem(
                    icon: "star.fill",
                    label: "Favoris",
                    isSelected: selectedTab == 2,
                    action: { selectedTab = 2 }
                )
            }
            .padding(.vertical, 8)
            .background(Color(nsColor: .controlBackgroundColor))
        }
        .frame(minWidth: 400, minHeight: 600)
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(label)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected ? .blue : .secondary)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
