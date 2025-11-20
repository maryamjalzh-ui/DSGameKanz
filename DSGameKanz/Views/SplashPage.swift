//
//  SplashPage.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 29/05/1447 AH.
//

import SwiftUI

struct SplashPage: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.primary.ignoresSafeArea() // خلفية سوده بسيطة (غيّري اللون لو تبين)
            
            Image("Group") // اسم الصورة اللي حطيتِها في الـ Assets
                .resizable()
                .scaledToFit()
                .padding(110)
                .scaleEffect(animate ? 1 : 0.8)
                .opacity(animate ? 1 : 0)
                .animation(.easeOut(duration: 1.0), value: animate)
        }
        .onAppear {
            animate = true
        }
    }
}



// عشان نشوف الايباد بالعرض حطوا ذا الكود في كل صفحه
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashPage()// اختياري: حطي نوع الآيباد
            .previewInterfaceOrientation(.landscapeLeft) // مهم: يخلي الكانفس عرضي
    }
}
