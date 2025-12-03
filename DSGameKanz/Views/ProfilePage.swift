//
//  ProfilePage.swift
//  DSGameKanz
//
//  Created by Abeer Alshabrami on 12/1/25.
//

import SwiftUI

struct ProfilePage: View {
    
    @State private var selected: String? = nil
    
    let characters = ["nina", "hopper", "jack", "yousef", "maya"]
    
    let unlockedCharacters: Set<String>
    
    
    private let characterSizes: [String: CGSize] = [
        "nina":   CGSize(width: 130, height: 110),
        "hopper": CGSize(width: 140, height: 129),
        "jack":   CGSize(width: 100, height: 115),
        "yousef": CGSize(width: 100,  height: 115),
        "maya":   CGSize(width: 130,  height: 140)
    ]
    
        private let characterOffsets: [String: CGSize] = [
        "nina":   CGSize(width: 0,  height: 10),
        "hopper": CGSize(width: -5,  height: 3),
        "jack":   CGSize(width: 0,  height: 8),
        "yousef": CGSize(width: 0,  height: 8),
        "maya":   CGSize(width: 0, height: 13)
    ]
    
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
                    characterBox(name: characters[2])
                    characterBox(name: characters[1]) 
                }
                
            
                HStack(spacing: 80) {
                    characterBox(name: characters[3])
                    characterBox(name: characters[4])
                }
                
                Spacer()
            }
        }
    }
    
    private func characterBox(name: String) -> some View {
        
        let isUnlocked = unlockedCharacters.contains(name)
        let boxSize: CGFloat = 140
        
        let size   = characterSizes[name]   ?? CGSize(width: 90, height: 90)
        let offset = characterOffsets[name] ?? CGSize(width: 0,  height: 0)
        
        return ZStack {
         
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
            
          
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
                .offset(x: offset.width, y: offset.height)
                .blur(radius: isUnlocked ? 0 : 4)
                .opacity(isUnlocked ? 1.0 : 0.6)
            
         
            if !isUnlocked {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.35))
                
                Image(systemName: "lock.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
            }
        }
        .overlay(
          
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    Color(
                        hex: isUnlocked
                        ? (selected == name ? "#A30000" : "#7B0909")
                        : "#7B0909"
                    ).opacity(isUnlocked ? 1 : 0.4),
                    lineWidth: (selected == name && isUnlocked) ? 12 : 10
                )
        )
        .frame(width: boxSize, height: boxSize)
        .contentShape(Rectangle())
        .onTapGesture {
            if isUnlocked {
                selected = name
            }
        }
    }
}

#Preview {
   
    ProfilePage(unlockedCharacters: ["nina", "jack"])
}
