
import SwiftUI

struct TopPlayerCard: View {
    let player: PlayerEntity
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Image
            AsyncImage(url: URL(string: player.image)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.gray // Placeholder
                }
            }
            .frame(width: 320, height: 420)
            .clipped()
            .overlay(
                Image(systemName: "heart.fill")
                    .foregroundColor(.mffPrimary)
                    .font(.system(size: 16)) // Smaller icon
                    .padding(12)
                    .background(Color.mffBackgroundDark.opacity(0.8)) // Back to the darker 0.8
                    .clipShape(Circle()) // "Pill" shape for icon
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 1) // Subtle border
                    )
                    .padding(24),
                alignment: .topTrailing
            )
            
            // Gradient Overlay
            LinearGradient(
                colors: [
                    Color.mffBackgroundDark.opacity(0.95),
                    Color.mffBackgroundDark.opacity(0.6),
                    .clear
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            
            // Content
            VStack(alignment: .leading, spacing: 0) {
                // Header (Badge Only)
                HStack(alignment: .top) {
                    Text("MÅNADENS SPELARE")
                        .font(.system(size: 10, weight: .black))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.mffPrimary)
                        .foregroundColor(.mffBackgroundDark)
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                .padding(.bottom, 4)
                
                HStack(alignment: .bottom) {
                    // Name and Stars
                    VStack(alignment: .leading, spacing: 4) {
                        VStack(alignment: .leading, spacing: -6) {
                            let nameComponents = player.name.split(separator: " ")
                            let firstName = nameComponents.dropLast().joined(separator: " ")
                            let lastName = nameComponents.last ?? ""
                            
                            if !firstName.isEmpty {
                                Text(firstName.uppercased())
                                    .font(.system(size: 32, weight: .heavy))
                                    .italic()
                                    .foregroundColor(.white)
                            }
                            Text(lastName.uppercased())
                                .font(.system(size: 32, weight: .heavy))
                                    .italic()
                                    .foregroundColor(.white)
                        }
                        
                        // Gold Stars
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                            Image(systemName: "star.fill")
                        }
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "FFD700")) // Gold color
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                    }
                    
                    Spacer()
                    
                    // Big Number
                    Text(player.number)
                        .font(.system(size: 56, weight: .heavy))
                        .italic()
                        .foregroundColor(.mffPrimary) // Solid Blue
                        .offset(y: 10)
                }
                .padding(.bottom, 16)
                
                // Stats Row
                HStack(spacing: 8) {
                    TopPlayerStatSlot(value: "\(player.stats_games ?? 0)", label: "MATCHER")
                    TopPlayerStatSlot(value: "\(player.stats_goals ?? 0)", label: "MÅL")
                    TopPlayerStatSlot(value: "\(player.stats_assists ?? 0)", label: "ASSISTS")
                }
            }
            .padding(24)
        }
        .frame(width: 320, height: 420)
        .background(Color.mffSurfaceDark)
        .cornerRadius(32)
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.1), .white.opacity(0.02)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.4), radius: 12, x: 0, y: 8)
    }
}

struct TopPlayerStatSlot: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 2) { // Tighter spacing
            Text(label)
                .font(.system(size: 9, weight: .black))
                .tracking(1)
                .foregroundColor(.mffPrimary.opacity(0.8))
            
            Text(value)
                .font(.system(size: 24, weight: .black))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 70) // Slightly shorter
        .background(Color.mffBackgroundDark.opacity(0.8))
        .cornerRadius(16)
        .overlay(
             RoundedRectangle(cornerRadius: 16)
                 .stroke(Color.white.opacity(0.1), lineWidth: 1)
         )
    }
}
