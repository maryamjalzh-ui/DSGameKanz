import SwiftUI

struct RoadMapPage: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("🗺️ خريطة المراحل")
                .font(.largeTitle)
            
            // تم حذف أي زر أو NavigationLink
        }
        .navigationTitle("المراحل")
    }
}

struct RoadMapPage_Previews: PreviewProvider {
    static var previews: some View {
        RoadMapPage()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
