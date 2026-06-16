import SwiftUI

struct FavoritesView: View {
    @ObservedObject var service: MatchService
    
    var favoriteTeams: [Team] {
        mockTeams.filter { service.isFavorite($0.id) }
    }
    
    var upcomingFavoriteMatches: [Match] {
        service.upcomingMatches.filter { match in
            favoriteTeams.contains { $0.id == match.homeTeam.id || $0.id == match.awayTeam.id }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Favoris")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            if favoriteTeams.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "star")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text("Aucune équipe favorite")
                        .font(.headline)
                    Text("Marquez vos équipes préférées pour suivre leurs matchs")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        // Favorite Teams
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Équipes Favorites")
                                .font(.headline)
                            
                            HStack {
                                ForEach(favoriteTeams) { team in
                                    VStack(spacing: 4) {
                                        Text(team.flag)
                                            .font(.system(size: 32))
                                        Text(team.code)
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                        
                                        Button(action: {
                                            service.toggleFavorite(teamId: team.id)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding()
                                    .background(Color(nsColor: .controlBackgroundColor))
                                    .cornerRadius(8)
                                }
                                Spacer()
                            }
                        }
                        
                        // Upcoming Matches
                        if !upcomingFavoriteMatches.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Prochains Matchs")
                                    .font(.headline)
                                
                                VStack(spacing: 12) {
                                    ForEach(upcomingFavoriteMatches.prefix(5)) { match in
                                        MatchCard(
                                            match: match,
                                            isFavorite: true,
                                            onFavoriteToggle: {
                                                service.toggleFavorite(teamId: match.homeTeam.id)
                                                service.toggleFavorite(teamId: match.awayTeam.id)
                                            }
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    FavoritesView(service: {
        let service = MatchService()
        service.toggleFavorite(teamId: "fra")
        service.toggleFavorite(teamId: "eng")
        return service
    }())
}
