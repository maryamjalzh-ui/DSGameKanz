//
//  ProfilePage.swift
//  DSGameKanz
//
//  Created by Abeer Alshabrami on 12/1/25.
//

import Foundation
import SwiftUI

struct ProfilePage: View {

    @State private var selected: String? = nil

    
    let characters = ["nina", "jack", "yousef", "maya", "hopper", "lola"]

    var body: some View {
        ZStack {
            
            
            Color(red: 254/255, green: 244/255, blue: 217/255)
                .ignoresSafeArea()
            
            
            Image("main")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 100) {
                
                Spacer().frame(height: 230)
                
                
                HStack(spacing: 55) {
                    characterBox(name: characters[0])
                    characterBox(name: characters[1])
                    characterBox(name: characters[2])
                }
                
                
                HStack(spacing: 80) {
                    characterBox(name: characters[3])
                    characterBox(name: characters[4])
                    
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func characterBox(name: String) -> some View {
        Button {
            selected = name
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        Color(hex: selected == name ? "#A30000" : "#7B0909"),
                        lineWidth: selected == name ? 12 : 10
                    )
                    .frame(width: 140, height: 140)
                    .scaleEffect(selected == name ? 1.06 : 1.0)
                    .animation(.spring(response: 0.25), value: selected)

                Image(name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .opacity(selected == name ? 1 : 0.92)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProfilePage()
}


