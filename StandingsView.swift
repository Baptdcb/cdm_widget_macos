import SwiftUI

struct StandingsView: View {
    @ObservedObject var service: MatchService
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Classements")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(service.standings) { group in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(group.name)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            VStack(spacing: 0) {
                                // Header
                                HStack {
                                    Text("Équipe")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    HStack(spacing: 12) {
                                        Text("J").frame(width: 20)
                                        Text("G").frame(width: 20)
                                        Text("N").frame(width: 20)
                                        Text("P").frame(width: 20)
                                        Text("Pts").frame(width: 24)
                                    }
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color(nsColor: .controlBackgroundColor))
                                
                                Divider()
                                
                                // Teams
                                ForEach(group.teams) { standing in
                                    HStack {
                                        HStack(spacing: 8) {
                                            Text(standing.team.flag)
                                                .font(.system(size: 20))
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(standing.team.name)
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                Text(standing.team.code)
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 12) {
                                            Text("\(standing.played)")
                                                .frame(width: 20)
                                            Text("\(standing.won)")
                                                .frame(width: 20)
                                            Text("\(standing.drawn)")
                                                .frame(width: 20)
                                            Text("\(standing.lost)")
                                                .frame(width: 20)
                                            Text("\(standing.points)")
                                                .frame(width: 24)
                                                .fontWeight(.bold)
                                        }
                                        .font(.caption)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    
                                    if standing.id != group.teams.last?.id {
                                        Divider()
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .background(Color(nsColor: .controlBackgroundColor))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    StandingsView(service: {
        let service = MatchService()
        return service
    }())
}
