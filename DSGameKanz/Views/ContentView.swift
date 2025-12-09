import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @StateObject private var progress = GameProgress()
    
    var body: some View {
        NavigationStack {
            Group {
                if showSplash {
                    SplashPage {
                        withAnimation {
                            showSplash = false   // بعد السبلش يروح للـ StartingPage
                        }
                    }
                } else {
                    StartingPage()
                }
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
