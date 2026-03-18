import SwiftUI

@main
struct 息岛App: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                
                if showSplash {
                    SplashView(isActive: $showSplash)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
        }
    }
}
