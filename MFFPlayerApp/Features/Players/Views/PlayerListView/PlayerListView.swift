
import SwiftUI
import SwiftData

// MARK: - Main View
struct PlayerListView: View {
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
                        PlayerListAllPlayersSection()
                    }
                    .padding(.bottom, 100)
                }
            }
            .overlay(alignment: .bottom) {
                CustomTabBar()
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
