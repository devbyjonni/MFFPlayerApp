
import SwiftUI

struct PlayerRowCard: View {
    let player: PlayerEntity
    
    var body: some View {
        NavigationLink(value: player) {
            HStack(spacing: 16) {
                Group {
                    if let imageData = player.imageData {
                        StoredImage(data: imageData)
                            .frame(width: 80, height: 110)
                            .clipped()
                    } else {
                        Color.mffSurfaceDark
                            .frame(width: 80, height: 110)
                    }
                }
                .background(Color.mffSurfaceDark)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    // Name Split (Sporty Style)
                    let nameComponents = player.name.split(separator: " ")
                    let firstName = nameComponents.dropLast().joined(separator: " ")
                    let lastName = nameComponents.last ?? ""
                    Text(firstName.uppercased())
                        .font(.system(size: 14, weight: .heavy))
                        .italic()
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(lastName.uppercased())
                        .font(.system(size: 20, weight: .black))
                        .italic()
                        .foregroundColor(.white)
                        .offset(x: -2)
                    // Position Badge
                    let position = player.position?.trimmingCharacters(in: .whitespaces) ?? ""
                    Text((position.isEmpty ? "MFF SPELARE" : position).uppercased())
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.mffPrimary.opacity(0.2))
                        .foregroundColor(.mffPrimary)
                        .clipShape(Capsule())
                        .offset(x: -4)
                        .padding(.top, 4)
                    // Stats Indicator
                    HStack(spacing: 4) {
                        CardCount(color: .mffAccentYellow, count: player.stats_yellow ?? 0)
                        CardCount(color: .mffAccentRed, count: player.stats_red ?? 0)
                    }
                    .offset(x: 4)
                    .padding(.top, 6)
                }
                
                Spacer()
                
                // Right Side: Number & Mini Stats
                VStack(alignment: .trailing, spacing: 8) {
                    
                    Text(player.number)
                        .font(.system(size: 32, weight: .black))
                        .italic()
                        .foregroundColor(.mffPrimary)
                    Spacer()
                    Button(action: { player.isFavorite.toggle() }) {
                        Image(systemName: player.isFavorite ? "star.fill" : "star")
                            .font(.system(size: 20))
                            .foregroundColor(player.isFavorite ? .yellow : .gray.opacity(0.5))
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
        } // NavigationLink
    }
}



struct CardCount: View {
    let color: Color
    let count: Int
    
    var body: some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 10, height: 14)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                )
            
            Text("\(count)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.7))
        }
    }
}
