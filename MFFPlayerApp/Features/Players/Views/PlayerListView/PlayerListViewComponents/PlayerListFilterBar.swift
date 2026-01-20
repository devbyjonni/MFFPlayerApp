
import SwiftUI

struct PlayerListFilterBar: View {
    @Binding var selectedCategory: PlayerCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(PlayerCategory.allCases, id: \.self) { category in
                    Button(action: {
                        withAnimation {
                            selectedCategory = category
                        }
                    }) {
                        Text(category.filterName)
                            .font(.system(size: 14, weight: .bold))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(selectedCategory == category ? Color.mffPrimary : Color.mffSurfaceDark)
                            .foregroundColor(selectedCategory == category ? .mffBackgroundDark : .white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.1), lineWidth: selectedCategory == category ? 0 : 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
