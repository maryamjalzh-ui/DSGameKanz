import SwiftUI

struct StartingPage: View {
    var body: some View {
        ZStack{
            Color.primary.ignoresSafeArea()
            Image("Start")
                .resizable()
                .scaledToFit()
            
            VStack(alignment: .leading){
                Text("هل انت مستعد لمساعدتي في إيجاد أصدقائي؟")
                    .font(.custom("Farah", size:24))
                    .padding(.leading, -450)
            }//end of Hstack
        }//end of Zstack
    }//end of var
}//end of struct

struct StartingPage_Previews: PreviewProvider {
    static var previews: some View {
        StartingPage()// اختياري: حطي نوع الآيباد
            .previewInterfaceOrientation(.landscapeLeft) // مهم: يخلي الكانفس عرضي
    }
}
