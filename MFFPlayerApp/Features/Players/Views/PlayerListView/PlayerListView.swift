
import SwiftUI
import SwiftData

// MARK: - Main View
struct PlayerListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var players: [PlayerEntity]
    @State private var selectedCategory: PlayerCategory = .all
    
    init() {}
    
    var body: some View {
        ZStack {
            // Background
            Color.mffBackgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                PlayerListHeader()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Section: Toppspelare (Carousel)
                        topPlayersSection
                        
                        // Section: Hela Truppen (List)
                        allPlayersSection
                    }
                    .padding(.bottom, 100) // Space for bottom nav
                }
            }
            
            // Bottom Navigation Overlay
            VStack {
                Spacer()
                CustomBottomBar()
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    // MARK: - Components
    

    
    private var topPlayersSection: some View {
        TopPlayersSection(favoritePlayers: favoritePlayers) { player in
            toggleFavorite(player)
        }
    }
    
    private var favoritePlayers: [PlayerEntity] {
        players.filter { $0.isFavorite }
    }
    
    private var allPlayersSection: some View {
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
                        toggleFavorite(player)
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
    
    private func toggleFavorite(_ player: PlayerEntity) {
        player.isFavorite.toggle()
    }
}
