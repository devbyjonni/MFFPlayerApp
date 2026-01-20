
import SwiftUI

struct CustomBottomBar: View {
    var body: some View {
        HStack(spacing: 0) {
            NavBarItem(icon: "house.fill", title: "HEM", isSelected: true)
            NavBarItem(icon: "person.3.fill", title: "TRUPPEN", isSelected: false)
            NavBarItem(icon: "flag.fill", title: "ODDS", isSelected: false)
            NavBarItem(icon: "person.circle.fill", title: "PROFIL", isSelected: false)
        }
        .padding(.top, 16)
        .padding(.bottom, 32)
        .background(
            Color.mffBackgroundDark.opacity(0.95)
                .background(.ultraThinMaterial)
        )
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.white.opacity(0.1)),
            alignment: .top
        )
        .frame(maxWidth: 450) // Restrict width on iPad/Desktop
    }
}

struct NavBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 24))
            
            Text(title)
                .font(.system(size: 10, weight: .black))
        }
        .foregroundColor(isSelected ? .mffPrimary : .gray)
        .frame(maxWidth: .infinity)
    }
}


