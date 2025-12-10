import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @StateObject private var progress = GameProgress()
    
    var body: some View {
        ZStack {
            // Your real app
            NavigationStack {
                StartingPage()
            }
            .opacity(showSplash ? 0 : 1)   // hide app while splash is showing
            
            // Splash on top
            if showSplash {
                SplashPage {
                    withAnimation(.easeOut(duration: 0.4)) {
                        showSplash = false   // بعد السبلش يروح للـ StartingPage
                    }
                }
                .transition(.opacity)
            }
        }
        .environmentObject(progress)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
