import SwiftUI
import PlaygroundSupport

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            
                MarketView() // Wrap MarketView with NavigationView
        }
    }
}
