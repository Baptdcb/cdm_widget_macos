import SwiftUI

struct StandingsView: View {
    @ObservedObject var service: MatchService
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Classements")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .foregroundColor(.white)
            
            if service.standings.isEmpty {
                VStack {
                    ProgressView()
                        .tint(.blue)
                    Text("Chargement...")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(service.standings) { standing in
                            HStack(spacing: 12) {
                                // Position
                                Text("\(standing.position)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 30)
                                
                                // Team Flag and Name
                                HStack(spacing: 8) {
                                    FlagImage(url: standing.team.flagURL)
                                        .frame(width: 24, height: 16)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(standing.team.tla ?? standing.team.name)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Text(standing.team.name)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Spacer()
                                
                                // Stats
                                HStack(spacing: 12) {
                                    VStack(alignment: .center, spacing: 2) {
                                        Text("\(standing.playedGames)")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                        Text("J")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    VStack(alignment: .center, spacing: 2) {
                                        Text("\(standing.won)")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                        Text("G")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    VStack(alignment: .center, spacing: 2) {
                                        Text("\(standing.goalDifference > 0 ? "+" : "")\(standing.goalDifference)")
                                            .font(.caption2)
                                            .foregroundColor(standing.goalDifference > 0 ? .green : .red)
                                        Text("DF")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("\(standing.points)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                        Text("Pts")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(8)
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
        StandingsView(service: MatchService())
    }
}
