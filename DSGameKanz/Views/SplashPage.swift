import SwiftUI

struct SplashPage: View {
    @State private var animate = false
    let onFinished: () -> Void          // <-- NEW

    var body: some View {
        ZStack {
            Color.primary.ignoresSafeArea()
            
            Image("Group")
                .resizable()
                .scaledToFit()
                .padding(110)
                .scaleEffect(animate ? 1 : 0.8)
                .opacity(animate ? 1 : 0)
                .animation(.easeOut(duration: 1.0), value: animate)
        }
        .onAppear {
            animate = true
            // wait then call onFinished
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
