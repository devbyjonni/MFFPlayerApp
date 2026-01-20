
import SwiftUI
import SwiftData

// MARK: - Main View
struct PlayerListView: View {
    @Environment(\.modelContext) private var modelContext
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
                        ListPlayerCarousel()
                        
                        // Section: Hela Truppen (List)
                        PlayerListAllPlayersSection(selectedCategory: $selectedCategory)
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
}
