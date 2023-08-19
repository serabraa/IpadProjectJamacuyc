import SwiftUI
import PlaygroundSupport


class WatchFavorites: ObservableObject {
    @Published var favorites: Set<UUID> = []
    
    func toggleFavorite(_ watch: Watch) {
        if favorites.contains(watch.id) {
            favorites.remove(watch.id)
        } else {
            favorites.insert(watch.id)
        }
    }
    
    func isFavorite(_ watch: Watch) -> Bool {
        return favorites.contains(watch.id)
    }
}

struct Watch: Identifiable {
    let id = UUID()
    let imageName: String?
    let name: String
    let price: Double
}

let watches: [Watch] = [
    Watch(imageName: "watchTest", name: "Elegant Timepiece", price: 249.99),
    Watch(imageName: "watchTest", name: "Sporty Chrono", price: 189.99),
    Watch(imageName: "watch3", name: "Classic Leather", price: 299.99),
    Watch(imageName: nil, name: "Empty Box", price: 0),
    Watch(imageName: "nonExistentImage", name: "Image Not Found", price: 0),
    // Add more watches here
]

struct WatchCell: View {
    @ObservedObject var favorites: WatchFavorites
    let watch: Watch
    
    var body: some View {
        VStack(spacing: 20) {
            if let imageName = watch.imageName,
               let image = UIImage(named: imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            } else {
                Color.clear
                    .frame(width: 100, height: 100)
            }
            
            Text(watch.name)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 50)
                .layoutPriority(1)
            
            Text("$\(watch.price, specifier: "%.2f")")
                .font(.subheadline)
            
            Button(action: {
                favorites.toggleFavorite(watch)
            }) {
                Image(systemName: favorites.isFavorite(watch) ? "heart.fill" : "heart")
                    .foregroundColor(favorites.isFavorite(watch) ? .red : .white)
                    .font(.system(size: 24))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Color.gray)
        .cornerRadius(3)
        .frame(width: 300, height: 600)
        .shadow(radius: 5)
    }
}
struct BottomBar: View {
    @Binding var scrollToTop: Bool
    @Binding var showFavoritesSheet: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            marketButton
            Spacer()
            favoritesButton
        }
        .frame(height: 40)
    }
    
    private var marketButton: some View {
        Button(action: {
            withAnimation {
                scrollToTop.toggle()
            }
        }) {
            Text("Market")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
        }
    }
    
    private var favoritesButton: some View {
        Button(action: {
            showFavoritesSheet.toggle()
        }) {
            Text("Favorites")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
        }
    }
}


struct ContentView: View {
    var body: some View {
        NavigationView {
            MarketView()
        }
    }
}




