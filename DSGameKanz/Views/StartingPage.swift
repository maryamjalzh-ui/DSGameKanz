import SwiftUI

struct StartingPage: View {
    var body: some View {
        NavigationStack{
            ZStack{
           Color.primary.ignoresSafeArea()
            Image("Start")
            .resizable()
          .edgesIgnoringSafeArea(.all)

                    
            
            VStack(alignment: .center, spacing: 8){
                Text("هل انت مستعد لمساعدتي")
                Text("في إيجاد أصدفائي؟")
            }//end of Vstack
            .font(.custom("Farah", size:50))
            .padding(.top, -220)
            .padding(.leading, -480)      .foregroundColor(.Burgundy)
            
            VStack {
                Spacer().frame(height: 280)   // move button down under the text
                NavigationLink(destination: CharacterChoice()) {
                    Text("ابدأ رحلتك")
                        .font(.custom("Farah", size:50))
                        .foregroundColor(.white)
                        .padding(.vertical, 18)
                        .padding(.horizontal, 40)
                        .background(Color.Burgundy)
                        .cornerRadius(35)
                }
                .padding(.top, -200)
                .padding(.leading, -430)
            }//end of vstack
            
        }//end of Zstack
         }//end of nagivsationstack
    }//end of var
    
}

    struct StartingPage_Previews: PreviewProvider {
        static var previews: some View {
            StartingPage()// اختياري: حطي نوع الآيباد
                .previewInterfaceOrientation(.landscapeLeft) // مهم: يخلي الكانفس عرضي
        }
    }//end of struct

