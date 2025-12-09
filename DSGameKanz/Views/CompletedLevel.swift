//
//  CompletedLevel.swift
//  DSGameKanz
//
//  Created by Tala Aldhahri on 11/06/1447 AH.
//


import SwiftUI

struct LevelCompletedView: View {
    var levelNumber: Int
    
    @EnvironmentObject var progress: GameProgress
    
    // MARK: - Character Logic
    var unlockedCharacterImageName: String? {
        switch levelNumber {
        case 2:
            return "level 2-happy"
        case 4:
            return "level 4-happy"
        case 6:
            return "level 6-happy"
        case 8:
            return "level 8-happy"
        case 10:
            return "level 10-happy"
        default:
            return nil
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
                    
                    if let imageName = unlockedCharacterImageName {
                        
                        Text("لقد حصلت على صديق جديد")
                            .font(.custom("Farah", size: 30))
                            .foregroundColor(.black.opacity(0.7))
                        
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .padding(.top, 5)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            // نسجّل أن اللاعب خلّص مرحلة
            progress.registerLevelCompleted()
        }
    }
}

struct LevelCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        LevelCompletedView(levelNumber: 2)
            .environmentObject(GameProgress())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
