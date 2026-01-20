
import SwiftUI

struct TopPlayersSection: View {
    let favoritePlayers: [PlayerEntity]
    let onToggleFavorite: (PlayerEntity) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .bottom) {
                Text("Dina favoritspelare")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            if favoritePlayers.isEmpty {
                // Empty State for Favorites
                VStack(spacing: 12) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 32))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("Du har inga favoriter än.\nMarkera spelare i listan nedan.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
                .padding(.horizontal, 24)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(favoritePlayers) { player in
                            TopPlayerCard(player: player, onToggleFavorite: {
                                onToggleFavorite(player)
                            })
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}
