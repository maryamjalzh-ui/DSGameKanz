//  //  RoadMap.swift
//  DSGameKanz
//
//  Created by Lujain Alrugabi on 01/12/2025.
//

import SwiftUI

struct MapLevel: Identifiable {
    let id: Int
    let xRatio: CGFloat
    let yRatio: CGFloat
    let isUnlocked: Bool
}

struct RoadMap: View {

    private let levels: [MapLevel] = [
        MapLevel(id: 1, xRatio: 0.08, yRatio: 0.24, isUnlocked: true),
        MapLevel(id: 2, xRatio: 0.36,  yRatio: 0.44, isUnlocked: false),
        MapLevel(id: 3, xRatio: 0.13, yRatio: 0.60, isUnlocked: false),
        MapLevel(id: 4, xRatio: 0.03,  yRatio: 0.79, isUnlocked: false),
        MapLevel(id: 5, xRatio: 0.17,  yRatio: 0.91, isUnlocked: false),
        MapLevel(id: 6, xRatio: 0.38,  yRatio: 0.88, isUnlocked: false),
        MapLevel(id: 7, xRatio: 0.49,  yRatio: 0.68, isUnlocked: false),
        MapLevel(id: 8, xRatio: 0.66,  yRatio: 0.35, isUnlocked: false),
        MapLevel(id: 9, xRatio: 0.77,  yRatio: 0.53, isUnlocked: false),
        MapLevel(id: 10, xRatio: 0.81,  yRatio: 0.86, isUnlocked: false),
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {

                // الخلفيةbackground
                Image("RoadMapp")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .offset(x: 0, y: -20)
                    

                // نص بداية رحلتك "Start your Journey" text
                VStack {
                    HStack {
                        Text("بداية رحلتك")
                            .font(.custom("Farah", size: 55))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .padding(.leading, 40)
                            .padding(.top, 50)
                        Spacer()
                    }
                    Spacer()
                }

                // نص لقد وصلت "You Arrived" text
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("لقد وصلت!")
                            .font(.custom("Farah", size: 55))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .padding(.trailing, 120)
                            .padding(.bottom, 80)
                    }
                }

                // الليفلات Levels
                ForEach(levels) { level in
                    if level.isUnlocked {
                        NavigationLink {
                            InLevelPage()
                        } label: {
                            levelCircle(unlocked: true)
                        }
                        .position(
                            x: level.xRatio * geo.size.width,
                            y: level.yRatio * geo.size.height
                        )
                    } else {
                        levelCircle(unlocked: false)
                            .position(
                                x: level.xRatio * geo.size.width,
                                y: level.yRatio * geo.size.height
                            )
                    }
                }

            }
        }
    }

    // شكل دائرة الليفل Level circle structure
    private func levelCircle(unlocked: Bool) -> some View {
        Circle()
            .fill(Color.gray)
            .frame(width: 86, height: 86)
            .overlay(
                Circle()
                    .stroke(
                        unlocked ? Color.black.opacity(0.9)
                                 : Color.white.opacity(0.4),
                        lineWidth: 4
                    )
            )
            .shadow(radius: unlocked ? 5 : 1)
    }
}

#Preview(traits: .landscapeLeft) {
    NavigationStack {
        RoadMap()
    }
}
