import SwiftUI

struct ContentView: View {
    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash {
                SplashPage {
                    withAnimation {
                        showSplash = false      // <-- بعد السبلش يروح للستارتنق
                    }
                }
            } else {
                StartingPage()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
