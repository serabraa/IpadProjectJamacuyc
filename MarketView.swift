import SwiftUI
import PlaygroundSupport

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
    let watch: Watch
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 20) {
            if let imageName = watch.imageName,
               let image = UIImage(named: imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100) // Set a fixed size for images
            } else {
                Color.clear
                    .frame(width: 100, height: 100) // Set the same fixed size for empty boxes
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
                isFavorite.toggle() // Toggle the favorite state
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .white) // Set the color based on favorite state
                    .font(.system(size: 24)) // Adjust the size of the heart icon
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

        }
        .padding()
        .background(Color.gray)
        .cornerRadius(3)
        .frame(width: 300, height: 600) // Set a fixed size for the entire cell
        .shadow(radius: 5)
        
    }
}



struct MarketView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var scrollToTop: Bool = false // Add a state to trigger scrolling
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
            
            VStack(spacing: 0) {
                Color.blue // Top fixed bar
                    .frame(height: 20) // Adjust the height as needed
                
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 125 ) {
                            ForEach(watches) { watch in
                                WatchCell(watch: watch)
                                    .id(watch.id) // Assign an ID to each cell
                            }
                        }
                        .padding()
                        .onChange(of: scrollToTop) { newValue in
                            if newValue {
                                withAnimation {
                                    scrollViewProxy.scrollTo(watches.first?.id, anchor: .top)
                                }
                                scrollToTop.toggle() // Reset the state to false
                            }
                        }
                    }
                }
                
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation {
                            scrollToTop.toggle() // Toggle the state to trigger scrolling
                        }
                    }) {
                        Text("Market")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                    }
                    
                    NavigationLink(destination: FavoritesView()) {
                        Text("Favorites")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                    }
                }
                .frame(height: 40) // Adjust the height as needed
            }
        }
    }
}

    

