
import SwiftUI

struct PlayerRowCard: View {
    let player: PlayerEntity
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            AsyncImage(url: URL(string: player.image)) { phase in
                if let image = phase.image {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else {
                    Color.mffSurfaceDark
                }
            }
            .frame(width: 48, height: 48)
            .background(Color.mffSurfaceDark)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                Text("#\(player.number) · \(player.position ?? "Spelare")".uppercased())
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Stats Indicator (Mini Demo)
            HStack(spacing: 12) {
                // Cards
                HStack(spacing: 4) {
                    CardCount(color: .mffAccentYellow, count: player.stats_yellow ?? 0)
                    CardCount(color: .mffAccentRed, count: player.stats_red ?? 0)
                }
                
                // Form Dots (Mock)
                HStack(spacing: 4) {
                    Circle().fill(Color.mffAccentGreen).frame(width: 6, height: 6)
                    Circle().fill(Color.mffAccentGreen).frame(width: 6, height: 6)
                    Circle().fill(Color.gray).frame(width: 6, height: 6)
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
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
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
