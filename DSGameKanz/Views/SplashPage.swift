import SwiftUI

struct SplashPage: View {
    @State private var animate = false
    let onFinished: () -> Void

    var body: some View {
        ZStack {
            Color.primary
                .ignoresSafeArea()
            
            Image("appIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .scaleEffect(animate ? 1.0 : 0.85)
                .opacity(animate ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animate = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
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
