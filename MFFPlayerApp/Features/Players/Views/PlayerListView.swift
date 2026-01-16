
import SwiftUI
import SwiftData

// MARK: - Main View
struct PlayerListView: View {
    @State private var viewModel: PlayerViewModel
    @Query private var players: [PlayerEntity]
    
    init(viewModel: PlayerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            // Background
            Color.mffBackgroundDark.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
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
        .task {
            await viewModel.loadPlayers()
        }
    }
    
    // MARK: - Components
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("HERRLAGET")
                    .font(.system(size: 20, weight: .black, design: .default)) // Replicating "extrabold italic" roughly
                    .italic()
                    .foregroundColor(.white)
                
                Text("MATCHDAG · 19:00")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1.5)
                    .foregroundColor(.mffPrimary)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                CircleButton(iconName: "bell.fill")
                CircleButton(iconName: "magnifyingglass")
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.mffBackgroundDark.opacity(0.8))
    }
    
    private var topPlayersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .bottom) {
                Text("Dina favoritspelare")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("Se alla") {
                    // Action
                }
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.mffPrimary)
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // Using first few players as "Top Players" for demo
                    ForEach(players.prefix(3)) { player in
                        TopPlayerCard(player: player)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private var allPlayersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Hela Truppen")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color.mffSurfaceDark)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 24)
            
            VStack(spacing: 12) {
                ForEach(players) { player in
                    PlayerRowCard(player: player)
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
