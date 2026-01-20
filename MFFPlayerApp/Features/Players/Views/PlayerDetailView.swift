
import SwiftUI
import SwiftData

struct PlayerDetailView: View {
    let player: PlayerEntity
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Image
                ZStack(alignment: .bottom) {
                    if let imageData = player.imageData {
                        StoredImage(data: imageData)
                            .frame(height: 500)
                            .clipped()
                    } else {
                        Color.mffSurfaceDark
                            .frame(height: 500)
                    }
                    
                    // Gradient Overlay
                    LinearGradient(
                        colors: [
                            Color.mffBackgroundDark,
                            Color.mffBackgroundDark.opacity(0.8),
                            Color.mffBackgroundDark.opacity(0.0)
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 300)
                    
                    // Name and Number Overlay
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: -5) {
                            Text(player.name.uppercased())
                                .font(.system(size: 40, weight: .black))
                                .italic()
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 10)
                            
                            let category = PlayerCategory.from(position: player.position)
                            Text(category == .all ? "SPELARE" : category.rawValue.uppercased())
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.mffPrimary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        Text(player.number)
                            .font(.system(size: 80, weight: .black))
                            .italic()
                            .foregroundColor(.white.opacity(0.1))
                    }
                    .padding(24)
                }
                
                VStack(spacing: 32) {
                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        DetailStatCard(value: "\(player.stats_games ?? 0)", label: "MATCHER")
                        DetailStatCard(value: "\(player.stats_goals ?? 0)", label: "MÅL")
                        DetailStatCard(value: "\(player.stats_assists ?? 0)", label: "ASSISTS")
                        
                        // Cards (Combined)
                        HStack(spacing: 12) {
                            CardCount(color: .mffAccentYellow, count: player.stats_yellow ?? 0)
                            CardCount(color: .mffAccentRed, count: player.stats_red ?? 0)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .background(Color.mffSurfaceDark)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                    
                    // Bio / Info
                    if let bio = player.bio {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SPELARPROFIL")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.mffPrimary)
                            
                            Text(bio)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(6)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(24)
                        .background(Color.mffSurfaceDark)
                        .cornerRadius(24)
                    }
                }
                .padding(24)
                .offset(y: -40) // Overlap slightly
            }
        }
        .background(Color.mffBackgroundDark.ignoresSafeArea())
        .edgesIgnoringSafeArea(.top)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { player.isFavorite.toggle() }) {
                    Image(systemName: player.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(player.isFavorite ? .red : .white)
                        .font(.system(size: 20, weight: .bold))
                }
            }
        }
    }
}

struct DetailStatCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 32, weight: .black))
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .tracking(1)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color.mffSurfaceDark)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
