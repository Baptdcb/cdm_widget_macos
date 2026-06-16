import SwiftUI

struct ContentView: View {
    @StateObject private var service = MatchService()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.12, blue: 0.25),
                    Color(red: 0.1, green: 0.2, blue: 0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("⚽ Coupe du Monde")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            Text("2026")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        
                        if service.isLoading {
                            ProgressView()
                                .tint(.blue)
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                
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
                
                Spacer()
                
                // Tab Bar
                HStack(spacing: 0) {
                    TabBarItem(
                        icon: "soccer.ball.fill",
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
                .padding(.vertical, 12)
                .background(Color.black.opacity(0.5))
            }
        }
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                Text(label)
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected ? .blue : .gray)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
