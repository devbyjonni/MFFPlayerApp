
import SwiftUI

struct PlayerListAllPlayersSection: View {
    let players: [PlayerEntity]
    @Binding var selectedCategory: PlayerCategory
    let onToggleFavorite: (PlayerEntity) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Hela Truppen")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // Filter Bar
            PlayerListFilterBar(selectedCategory: $selectedCategory)
            
            LazyVStack(spacing: 12) {
                ForEach(filteredPlayers) { player in
                    PlayerRowCard(player: player, onToggleFavorite: {
                        onToggleFavorite(player)
                    })
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var filteredPlayers: [PlayerEntity] {
        guard let filterValue = selectedCategory.databaseValue else {
            return players
        }
        return players.filter { player in
            guard let position = player.position else { return false }
            return position.lowercased().contains(filterValue.lowercased())
        }
    }
}
