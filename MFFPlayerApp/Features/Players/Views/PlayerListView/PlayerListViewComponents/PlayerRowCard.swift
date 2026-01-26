
import SwiftUI

struct PlayerRowCard: View {
    let player: PlayerEntity
    
    var body: some View {
        NavigationLink(value: player) {
            ZStack(alignment: .trailing) {
                // 0. Background Number (Watermark)
                Text(player.number)
                    .font(.system(size: 96, weight: .black))
                    .italic()
                    .foregroundColor(Color.mffPrimary.opacity(0.03)) // Subtle watermark
                    .offset(x: -20)
                    .allowsHitTesting(false)
                
                HStack(spacing: 0) {
                    // 1. Image
                    Group {
                        if let imageData = player.imageData {
                            StoredImage(data: imageData)
                        } else {
                            Color.mffSurfaceDark
                        }
                    }
                    .frame(width: 90, height: 115) // Slightly adjusted for balance
                    .clipped()
                    .background(Color.mffSurfaceDark)
                    
                    // 2. Info Group
                    VStack(alignment: .leading, spacing: 4) {
                        // Name Hierarchy
                        VStack(alignment: .leading, spacing: -2) {
                            // First Name (Upper Label)
                            let nameComponents = player.name.split(separator: " ")
                            let firstName = nameComponents.dropLast().joined(separator: " ")
                            let lastName = nameComponents.last ?? ""
                            
                            if !firstName.isEmpty {
                                Text(firstName.uppercased())
                                    .font(.system(size: 14, weight: .semibold)) // Distinct weight
                                    .tracking(0.5)
                                    .foregroundColor(.mffPrimary.opacity(0.8)) // Accent color
                            }
                            
                            // Last Name (Hero)
                            Text(lastName.uppercased())
                                .font(.system(size: 22, weight: .black)) // Reduced size
                                .italic()
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        
                        // Position
                        Text((player.position ?? "MFF SPELARE").uppercased())
                            .font(.system(size: 11, weight: .bold))
                            .tracking(1)
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.top, 2)
                        
                        // 3. Stats Zone (Pill)
                        HStack(spacing: 8) {
                            HStack(spacing: 6) {
                                CardCount(color: .yellow, count: player.statsYellow ?? 0)
                                CardCount(color: .red, count: player.statsRed ?? 0)
                            }
                        }
                        .padding(.top, 6)
                    }
                    .padding(.leading, 16)
                    .padding(.vertical, 12)
                    
                    Spacer()
                    
                    // 4. Action (Heart - Right Aligned)
                    Button(action: { player.isFavorite.toggle() }) {
                        Image(systemName: player.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 22))
                            .foregroundColor(player.isFavorite ? .mffPrimary : .white.opacity(0.2))
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 24)
                }
            }
            .background(Color(hex: "1C2C42"))
            .cornerRadius(20)
            .padding(.horizontal, 4)
            .clipped() // Clip the watermark number
        }
    }
}



struct CardCount: View {
    let color: Color
    let count: Int
    
    var body: some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 14, height: 18) // Larger size
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.black.opacity(0.2), lineWidth: 0.5)
                )
            
            Text("\(count)")
                .font(.system(size: 14, weight: .bold)) // Larger font
                .foregroundColor(.white)
        }
    }
}
