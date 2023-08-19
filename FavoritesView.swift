import SwiftUI
import PlaygroundSupport

struct FavoritesView: View {
    @ObservedObject var favorites: WatchFavorites
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 125) {
                    ForEach(watches) { watch in
                        if favorites.isFavorite(watch) {
                            WatchCell(favorites: favorites, watch: watch)
                                .id(watch.id)
                        }
                    }
                    
                    if favorites.favorites.isEmpty {
                        Text("You do not have favorite watches")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .padding()
            }
            .navigationTitle("Favorites")
        }
    }
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
}
