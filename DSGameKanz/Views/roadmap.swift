import SwiftUI

struct MapLevel: Identifiable {
    let id: Int
    let xRatio: CGFloat
    let yRatio: CGFloat
    let isUnlocked: Bool
}


struct RoadMap: View {

    @EnvironmentObject var progress: GameProgress

    private var levels: [MapLevel] {
        [
            MapLevel(id: 1, xRatio: 0.09, yRatio: 0.20, isUnlocked: true),
            MapLevel(id: 2, xRatio: 0.36, yRatio: 0.40, isUnlocked: progress.completedLevels >= 1),
            MapLevel(id: 3, xRatio: 0.13, yRatio: 0.60, isUnlocked: progress.completedLevels >= 2),
            MapLevel(id: 4, xRatio: 0.03, yRatio: 0.79, isUnlocked: progress.completedLevels >= 3),
            MapLevel(id: 5, xRatio: 0.17, yRatio: 0.91, isUnlocked: progress.completedLevels >= 4),
            MapLevel(id: 6, xRatio: 0.38, yRatio: 0.85, isUnlocked: progress.completedLevels >= 5),
            MapLevel(id: 7, xRatio: 0.49, yRatio: 0.66, isUnlocked: progress.completedLevels >= 6),
            MapLevel(id: 8, xRatio: 0.65, yRatio: 0.33, isUnlocked: progress.completedLevels >= 7),
            MapLevel(id: 9, xRatio: 0.76, yRatio: 0.52, isUnlocked: progress.completedLevels >= 8),
            MapLevel(id: 10, xRatio: 0.81, yRatio: 0.86, isUnlocked: progress.completedLevels >= 9),
        ]
    }


    var body: some View {
        GeometryReader { geo in
            ZStack {

                // الخلفية
                Image("RoadMapp")
                    .resizable()
                    .ignoresSafeArea()

                // زر Profile
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink {
                            ProfilePage()
                        } label: {
                            Image("watch")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 140, height: 140)
                                .padding(.top, -50)
                        }
                    }
                    Spacer()
                }

                // نص بداية رحلتك
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

                // نص لقد وصلت
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

                // الليفلات
                ForEach(levels) { level in

                    let isUnlocked = progress.completedLevels >= level.id - 1

                    if isUnlocked {
                        NavigationLink {
                            destinationView(for: level.id)
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

    // MARK: - ربط كل ليفل بصفحته
    @ViewBuilder
    private func destinationView(for level: Int) -> some View {
        switch level {
        case 1:
            InLevelPage()
        case 2:
            Level2Page()
        case 3:
            Level3Page()
        case 4:
            Level4Page()
        case 5:
            Level5Page()
        case 6:
            Level6Page()
        case 7:
            Level7Page()
        case 8:
            Level8Page()
        case 9:
            Level9Page()
        case 10:
            Level10Page()
        default:
            InLevelPage()
        }
    }

    // شكل دائرة الليفل
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

#Preview(traits: .landscapeLeft) {
    NavigationStack {
        RoadMap()
            .environmentObject(GameProgress())
    }
}
