
import SwiftUI

struct PlayerListHeader: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("HERRLAGET")
                    .font(.system(size: 20, weight: .black, design: .default))
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
}
