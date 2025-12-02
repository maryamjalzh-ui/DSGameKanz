//
//  CharacterChoice.swift
//  DSGameKanz
//
//  Created by Sarah Aleissa on 01/12/2025.
//

import SwiftUI

struct CharacterChoice: View {
    var body: some View {
        NavigationStack{
       
            ZStack{
                Color.primary.ignoresSafeArea()
                Image("Choose")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                
                
                
                
            }//end of zstack
        }//end of navigation)
        .navigationBarBackButtonHidden(true)
    }//end of var
}//end of struct

struct CharacterChoice_Previews: PreviewProvider {
    static var previews: some View {
        CharacterChoice()// اختياري: حطي نوع الآيباد
            .previewInterfaceOrientation(.landscapeLeft) // مهم: يخلي الكانفس عرضي
    }
}//end of struct
