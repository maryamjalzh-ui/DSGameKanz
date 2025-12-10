import SwiftUI

struct SplashPage: View {
    @State private var animate = false
    let onFinished: () -> Void

    var body: some View {
        ZStack {
            Color.primary.ignoresSafeArea()
            
            Image("Group")
                .resizable()
                .scaledToFit()
                .padding(110)
                .scaleEffect(animate ? 1.0 : 0.7)   // smoother start
                .opacity(animate ? 1 : 0)
        }
        .onAppear {
            // start animation
            withAnimation(.easeOut(duration: 1.0)) {
                animate = true
            }
            
            // wait then go to next page
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onFinished()
            }
        }
    }
}

struct SplashPage_Previews: PreviewProvider {
    static var previews: some View {
        SplashPage { }
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
