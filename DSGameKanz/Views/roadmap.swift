//  RoadMap.swift
//  DSGameKanz
//
//  Created by Lujain Alrugabi on 01/12/2025.
//
import SwiftUI

// موديل لليفل على الخريطة
struct MapLevel: Identifiable {
    let id: Int
    let xRatio: CGFloat
    let yRatio: CGFloat
    let isUnlocked: Bool
}

struct RoadMap: View {

    // الليفلات مع الإحداثيات الصحيحة
    private let levels: [MapLevel] = [
        MapLevel(id: 0, xRatio: 0.11, yRatio: 0.26, isUnlocked: true),
        MapLevel(id: 1, xRatio: 0.19, yRatio: 0.50, isUnlocked: false),
        MapLevel(id: 2, xRatio: 0.46,  yRatio: 0.34, isUnlocked: false),
        MapLevel(id: 3, xRatio: 0.63,  yRatio: 0.42, isUnlocked: false),
        MapLevel(id: 4, xRatio: 0.33,  yRatio: 0.77, isUnlocked: false),
        MapLevel(id: 5, xRatio: 0.50,  yRatio: 0.62, isUnlocked: false),
        MapLevel(id: 6, xRatio: 0.80,  yRatio: 0.65, isUnlocked: false),
        MapLevel(id: 7, xRatio: 0.87,  yRatio: 0.84, isUnlocked: false)
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {

                // صورة الخريطة نفسها (نفس مقاس BluredMap)
                Image("RoadMap")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                // نص بداية رحلتك (أعلى اليسار)
                VStack {
                    HStack {
                        Text("بداية رحلتك")
                            .font(.custom("Farah", size: 40))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .padding(.leading, -90)
                            .padding(125)
                        Spacer()
                    }
                    Spacer()
                }

                // نص النهاية عند الكنز (أسفل اليمين)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("لقد وصلت!")
                            .font(.custom("Farah", size: 40))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .padding(.trailing, 130)
                            .padding(.bottom, 150)
                    }
                }

                // الليفلات فوق الدوائر الحمراء تماماً
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

    // شكل دائرة الليفل
    private func levelCircle(unlocked: Bool) -> some View {
        Circle()
            .fill(Color.white)
            .frame(width: 50, height: 55)
            .overlay(
                Circle()
                    .stroke(
                        unlocked ? Color.yellow.opacity(0.9)
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
