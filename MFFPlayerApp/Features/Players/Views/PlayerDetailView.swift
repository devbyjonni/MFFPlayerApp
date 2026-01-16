import SwiftUI

struct PlayerDetailView: View {
    let player: PlayerEntity
    var viewModel: PlayerViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Large Hero Image
                AsyncImage(url: URL(string: player.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 5)
                    } else if phase.error != nil {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray.opacity(0.3))
                    } else {
                        ProgressView()
                            .frame(height: 200)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                // Player Info
                VStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text(player.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        // New Details: Position & Age
                        if let position = player.position {
                            Text(position.capitalized)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        if let dob = player.dob {
                            Text("Born: \(dob)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if !player.number.isEmpty {
                        Text("#\(player.number)")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(Capsule())
                    }
                    
                    // Bio Section
                    if let bio = player.bio, !bio.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Om \(player.name)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(bio)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)
                        .padding(.horizontal)
                        .background(Color(.systemGray6).opacity(0.5))
                        .cornerRadius(12)
                    } else if player.bio == nil {
                        // Loading State for Bio
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Loading details...")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.top)
                    }
                }
                .padding(.horizontal)
                
                .padding(.horizontal)
                
                // Stats Grid
                if let games = player.stats_games {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Säsongen 2025")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            StatCard(title: "Matcher", value: "\(games)", icon: "sportscourt")
                            StatCard(title: "Mål", value: "\(player.stats_goals ?? 0)", icon: "soccerball")
                            StatCard(title: "Assist", value: "\(player.stats_assists ?? 0)", icon: "arrow.up.right")
                            StatCard(title: "Gula", value: "\(player.stats_yellow ?? 0)", icon: "square.fill", iconColor: .yellow)
                            StatCard(title: "Röda", value: "\(player.stats_red ?? 0)", icon: "square.fill", iconColor: .red)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("Player Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Fetch more details when view appears
            await viewModel.fetchDetails(for: player)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var iconColor: Color = .primary
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
