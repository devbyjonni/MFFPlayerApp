
import SwiftUI

struct PlayerRowCard: View {
    let player: PlayerEntity
    let onToggleFavorite: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // ... (rest is same until Right Side)

            // Avatar (Taller Portrait)
            Group {
                if let imageData = player.imageData {
                    StoredImage(data: imageData)
                        .frame(width: 80, height: 110)
                        .clipped()
                } else {
                    AsyncImage(url: URL(string: player.image)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Color.mffSurfaceDark
                        }
                    }
                    .frame(width: 80, height: 110)
                    .clipped()
                }
            }
            .background(Color.mffSurfaceDark)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            
            // Info
            VStack(alignment: .leading, spacing: 2) {
                // Name Split (Sporty Style)
                let nameComponents = player.name.split(separator: " ")
                let firstName = nameComponents.dropLast().joined(separator: " ")
                let lastName = nameComponents.last ?? ""
                
                if !firstName.isEmpty {
                    Text(firstName.uppercased())
                        .font(.system(size: 14, weight: .heavy))
                        .italic()
                        .foregroundColor(.white.opacity(0.8))
                }
                Text(lastName.uppercased())
                    .font(.system(size: 20, weight: .black))
                    .italic()
                    .foregroundColor(.white)
                
                // Position Badge
                let category = PlayerCategory.from(position: player.position)
                Text(category.rawValue.uppercased())
                    .font(.system(size: 9, weight: .bold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.mffPrimary.opacity(0.2))
                    .foregroundColor(.mffPrimary)
                    .clipShape(Capsule())
                    .padding(.top, 4)
            }
            
            Spacer()
            
            // Right Side: Number & Mini Stats
            VStack(alignment: .trailing, spacing: 8) {
                // Heart Button
                Button(action: onToggleFavorite) {
                    Image(systemName: player.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(player.isFavorite ? .red : .gray.opacity(0.5))
                }
                .padding(.bottom, 4)
                
                Text(player.number)
                    .font(.system(size: 32, weight: .black))
                    .italic()
                    .foregroundColor(.mffPrimary)
                
                // Stats Indicator
                HStack(spacing: 12) {
                    if (player.stats_yellow ?? 0) > 0 || (player.stats_red ?? 0) > 0 {
                        HStack(spacing: 4) {
                            CardCount(color: .mffAccentYellow, count: player.stats_yellow ?? 0)
                            CardCount(color: .mffAccentRed, count: player.stats_red ?? 0)
                        }
                    }
                    
                    // Form Dots (Mock)
                    HStack(spacing: 4) {
                        Circle().fill(Color.mffAccentGreen).frame(width: 6, height: 6)
                        Circle().fill(Color.mffAccentGreen).frame(width: 6, height: 6)
                        Circle().fill(Color.gray).frame(width: 6, height: 6)
                    }
                }
            }
        }
        .padding(12)
        .background(
            LinearGradient(
                colors: [Color(hex: "16253B"), Color(hex: "0A1628")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20) // More rounded
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

// Helper for off-thread image decoding
struct StoredImage: View {
    let data: Data
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.mffSurfaceDark
            }
        }
        .task {
            // Decode off main thread to prevent scroll hitching
            if image == nil {
                image = await Task.detached(priority: .userInitiated) {
                    UIImage(data: data)
                }.value
            }
        }
    }
}

struct CardCount: View {
    let color: Color
    let count: Int
    
    var body: some View {
        HStack(spacing: 2) {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 8, height: 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                )
            
            Text("\(count)")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
        }
    }
}
