
import SwiftData
import SwiftUI

struct ListPlayerCarousel: View {
    // Queries
    @Query(filter: #Predicate<PlayerEntity> { $0.isSpotlight }) private var spotlightPlayers: [PlayerEntity]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if spotlightPlayers.isEmpty {
                // Should only happen if database is empty or spotlight hasn't run yet
                EmptyView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(spotlightPlayers) { player in
                            CarouselPlayerCard(player: player)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}
