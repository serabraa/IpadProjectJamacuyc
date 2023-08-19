import SwiftUI
import PlaygroundSupport
import Combine

struct MarketView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @StateObject private var favorites = WatchFavorites()
    @State private var scrollToTop = false
    @State private var showFavoritesSheet = false
    @State private var searchText = ""
    @State private var filteredWatches: [Watch] = watches
    
    var body: some View {
        ZStack {
            Color(hex:"#9DB2BF")
            
            VStack(spacing: 0) {
                topBar
                mainScrollView
                BottomBar(scrollToTop: $scrollToTop, showFavoritesSheet: $showFavoritesSheet)
            }
            .navigationTitle("Watch Market")
        }
        .sheet(isPresented: $showFavoritesSheet) {
            FavoritesView(favorites: favorites)
        }
    }
    
    private var topBar: some View {
        VStack(spacing: 0) {
            Color(hex: "#27374D").frame( height:40)
            
            HStack {
                
                TextField("Search by name", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            
            }
        }
    }
    
    private var mainScrollView: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(filteredWatches) { watch in
                        WatchCell(favorites: favorites, watch: watch)
                            .id(watch.id)
                    }
                }
                .padding()
                .onChange(of: searchText) { newValue in
                    if newValue.isEmpty {
                        filteredWatches = watches
                    } else {
                        filteredWatches = watches.filter {
                            $0.name.lowercased().contains(newValue.lowercased())
                        }
                    }
                }
                .padding()
                .onChange(of: scrollToTop) { newValue in
                    if newValue {
                        withAnimation {
                            scrollViewProxy.scrollTo(watches.first?.id, anchor: .top)
                        }
                        scrollToTop.toggle()
                    }
                }
            }
        }
    }
    
    private var bottomButtons: some View {
        HStack(spacing: 0) {
            marketButton
            Spacer()
            favoritesButton
        }
        .frame(height: 40)
        .background(Color(hex: "9DB2BF")) // Set the background color for the containing HStack
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
        }
    }
    
    private var favoritesButton: some View {
        Button(action: {
            showFavoritesSheet.toggle()
        }) {
            Text("Favorites")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }

}
