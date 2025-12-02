//
//  CompletedLevel.swift
//  DSGameKanz
//
//  Created by Tala Aldhahri on 11/06/1447 AH.
//


import SwiftUI

struct LevelCompletedView: View {
    var levelNumber: Int
    
    // MARK: - Character Logic
    // This computed property returns the Name of the image for the specific level.
    // If it returns nil, it means no character is unlocked (odd levels).
    var unlockedCharacterImageName: String? {
        switch levelNumber {
        case 2:
            return "level 2-happy" // The girl in pink dress
        case 4:
            return "level 4-happy" // The girl with the torch
        case 6:
            return "level 6-happy" // The man with the shield
        case 8:
            return "level 8-happy" // The boy in blue
        case 10:
            return "level 10-happy" // The man with red hat and torch
        default:
            return nil // Odd levels (1, 3, 5, 7, 9) return nothing
        }
    }
    
    var body: some View {
        ZStack {
            // 1. Background Layer
            Image("BluredMap")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // 2. The Scroll/Map Holder Layer
            ZStack {
                Image("HandsOnMap")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding()
                
                // 3. Content Layer
                VStack(spacing: 15) {
                    
                    Text("أحسنت!")
                        .font(.custom("Farah", size: 50))
                        .foregroundColor(Color.CinnamonWood)
                        .fontWeight(.bold)
                    
                    // Check if we have a character image for this level
                    if let imageName = unlockedCharacterImageName {
                        
                        Text("لقد حصلت على صديق جديد")
                            .font(.custom("Farah", size: 30))
                            .foregroundColor(.black.opacity(0.7))
                        
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180) // Adjust height to fit inside the paper
                            .padding(.top, 5)
                            // Adds a nice pop-in animation
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - Previews
struct LevelCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview: Level 2 (Should show Girl in Pink)
        LevelCompletedView(levelNumber: 2)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("Level 2 (Pink Girl)")
        
        // Preview: Level 6 (Should show Man with Shield)
        LevelCompletedView(levelNumber: 6)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("Level 6 (Shield Man)")

        // Preview: Level 3 (Odd level - Text only, no character)
        LevelCompletedView(levelNumber: 3)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("Level 3 (No Character)")
    }
}
