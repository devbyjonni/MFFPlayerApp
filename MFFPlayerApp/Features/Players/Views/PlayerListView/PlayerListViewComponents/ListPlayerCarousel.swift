
import SwiftData
import SwiftUI

struct ListPlayerCarousel: View {
    // Queries
    @Query(filter: #Predicate<PlayerEntity> { $0.isSpotlight }) private var spotlightPlayers: [PlayerEntity]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .bottom) {
                Text("I Rampljuset")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            if spotlightPlayers.isEmpty {
                // Should only happen if database is empty or spotlight hasn't run yet
                EmptyView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(spotlightPlayers) { player in
                            TopPlayerCard(player: player)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}
