
import SwiftUI

// Helper for off-thread image decoding
struct StoredImage: View {
    let data: Data
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.mffSurfaceDark
            }
        }
        .task {
            // Decode off main thread to prevent scroll hitching
            if image == nil {
                image = await Task.detached(priority: .userInitiated) {
                    UIImage(data: data)
                }.value
            }
        }
    }
}
