import SwiftUI

struct FavoritesView: View {
    @ObservedObject var service: MatchService
    
    var favoriteTeams: [Team] {
        var teams: [Team] = []
        for match in service.matches {
            if service.isFavorite(match.homeTeam.id) && !teams.contains(match.homeTeam) {
                teams.append(match.homeTeam)
            }
            if service.isFavorite(match.awayTeam.id) && !teams.contains(match.awayTeam) {
                teams.append(match.awayTeam)
            }
        }
        return teams
    }
    
    var upcomingFavoriteMatches: [Match] {
        service.upcomingMatches.filter { match in
            service.isFavorite(match.homeTeam.id) || service.isFavorite(match.awayTeam.id)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Favoris")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .foregroundColor(.white)
            
            if favoriteTeams.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "star")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("Aucune équipe favorite")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Cliquez sur l'étoile pour suivre vos équipes")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        // Favorite Teams
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Équipes Favorites")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            HStack {
                                ForEach(favoriteTeams.prefix(4)) { team in
                                    VStack(spacing: 8) {
                                        FlagImage(url: team.flagURL)
                                            .frame(height: 40)
                                        
                                        Text(team.tla ?? team.name)
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                        
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
                                    .background(Color.white.opacity(0.08))
                                    .cornerRadius(8)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        // Upcoming Matches
                        if !upcomingFavoriteMatches.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Prochains Matchs")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 12) {
                                    ForEach(upcomingFavoriteMatches.prefix(5)) { match in
                                        MatchCard(match: match, service: service)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        FavoritesView(service: MatchService())
    }
}
