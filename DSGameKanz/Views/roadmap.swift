//
// RoadMap.swift
// الكود النهائي: بدون إعادة تعريف InLevelPage
//

import SwiftUI

// **********************************************
// تم حذف تعريف struct InLevelPage لتجنب خطأ Invalid redeclaration
// لأنها موجودة بالفعل في مشروعك.
// **********************************************

struct MapLevel: Identifiable {
    let id: Int
    let xRatio: CGFloat
    let yRatio: CGFloat
    let isUnlocked: Bool
}

struct RoadMap: View {

    private let levels: [MapLevel] = [
        MapLevel(id: 1, xRatio: 0.09, yRatio: 0.20, isUnlocked: true),
        MapLevel(id: 2, xRatio: 0.36, yRatio: 0.40, isUnlocked: false),
        MapLevel(id: 3, xRatio: 0.13, yRatio: 0.60, isUnlocked: false),
        MapLevel(id: 4, xRatio: 0.03, yRatio: 0.79, isUnlocked: false),
        MapLevel(id: 5, xRatio: 0.17, yRatio: 0.91, isUnlocked: false),
        MapLevel(id: 6, xRatio: 0.38, yRatio: 0.85, isUnlocked: false),
        MapLevel(id: 7, xRatio: 0.49, yRatio: 0.66, isUnlocked: false),
        MapLevel(id: 8, xRatio: 0.65, yRatio: 0.33, isUnlocked: false),
        MapLevel(id: 9, xRatio: 0.76, yRatio: 0.52, isUnlocked: false),
        MapLevel(id: 10, xRatio: 0.81, yRatio: 0.86, isUnlocked: false),
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {

                // الخلفيةbackground
                Image("RoadMapp")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)

                // 1. زر "Watch" الموجه لـ ProfilePage
                VStack {
                    HStack {
                        Spacer() // لدفع الزر إلى أقصى اليمين

                        NavigationLink {
                            ProfilePage()
                        } label: {
                            Image("watch") // اسم الصورة من Assets
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 140, height: 140)
                                .padding(.trailing, 0)
                                .padding(.top, -50)
                        }
                    }
                    Spacer()
                }

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
                            .padding(.bottom, 20)
                    }
                }

                // الليفلات Levels
                ForEach(levels) { level in
                    if level.isUnlocked {
                        NavigationLink {
                            InLevelPage() // هذا يستدعي الـ struct الموجودة في ملفك الأصلي
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
            .fill(Color.white)
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

// التعديل لتشغيل المعاينة (Preview) بنجاح
#Preview(traits: .landscapeLeft) {
    // يجب افتراض وجود struct GameProgress
    // إذا لم يكن موجوداً، استبدل .environmentObject(previewProgress) بـ .environmentObject(GameProgress())
    let previewProgress = GameProgress()

    return NavigationStack {
        RoadMap()
            .environmentObject(previewProgress)
    }
}
