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
                            .padding(.vertical, 10)
                            .foregroundColor(selectedTab == index ? .white : .gray)
                            .background(
                                selectedTab == index ?
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .blue.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) : LinearGradient(
                                    gradient: Gradient(colors: [.clear, .clear]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(Color.black.opacity(0.2))
            
            // Matches List
            if service.isLoading {
                VStack {
                    ProgressView()
                        .tint(.blue)
                    Text("Chargement des matchs...")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .frame(maxHeight: .infinity)
            } else if let error = service.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.red)
                    Text("Erreur")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Button(action: { service.fetchWorldCupMatches() }) {
                        Text("Réessayer")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }
                .frame(maxHeight: .infinity)
            } else if displayedMatches.isEmpty {
                VStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 32))
                        .foregroundColor(.gray)
                    Text("Aucun match")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(displayedMatches) { match in
                            MatchCard(match: match, service: service)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        MatchesView(service: MatchService())
    }
}
