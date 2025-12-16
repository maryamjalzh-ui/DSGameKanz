import SwiftUI

struct LevelCompletedView: View {

    let levelNumber: Int
    @Binding var goToMap: Bool

    @EnvironmentObject var progress: GameProgress

    // MARK: - Character Logic
    var unlockedCharacterImageName: String? {
        // فقط ليفلات زوجية ما عدا الأخير
        guard levelNumber % 2 == 0, levelNumber < 10 else { return nil }

        // 🔴 حالة خاصة: Level 2
        if levelNumber == 2 {
            if progress.mainCharacter == "jack" {
                return "level 2-happy"   // 👦
            } else {
                return "level2happyjack"     // 👧 (نينا)
            }
        }

        // باقي الليفلات نفس السابق
        return "level \(levelNumber)-happy"
    }

    
    // MARK: - نهاية اللعبة
    var isFinalLevel: Bool {
        levelNumber == 10
    }

    var body: some View {
        ZStack {

            Image("BluredMap")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ZStack {
                Image("HandsOnMap")
                    .resizable()
                    .scaledToFit()
                    .padding()

                VStack(spacing: 0) {

                    Text("أحسنت!")
                        .font(.custom("Farah", size: 50))
                        .foregroundColor(.CinnamonWood)
                        .shadow(radius: 10)

                    // =========================
                    // 🏁 حالة نهاية اللعبة (Level 10)
                    // =========================
                    if isFinalLevel {

                        // 🔽 غيّري النص براحتك
                        Text(" لقد أنهيت الرحلة بنجاح!")
                            .font(.custom("Farah", size: 34))
                            .foregroundColor(.black.opacity(0.75))
                            .shadow(radius: 8)
                        

                        // 🔽 غيّري اسم الصورة براحتك
                        Image("FinalLevel")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 500)

                    }
                    // =========================
                    // 🤝 فتح صديق جديد (بقية الليفلات الزوجية)
                    // =========================
                    else if let imageName = unlockedCharacterImageName {

                        Text("لقد حصلت على صديق جديد")
                            .font(.custom("Farah", size: 30))
                            .foregroundColor(.black.opacity(0.7))
                            .shadow(radius: 10)

                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                    }

                    Button {
                        // ✅ تحديث التقدم
                        progress.completeLevelIfNeeded(levelNumber)

                        // ✅ رجوع فعلي للرود ماب
                        goToMap = true
                    } label: {
                        Text("العودة للخريطة")
                            .font(.custom("Farah", size: 30))
                            .foregroundColor(.white)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 14)
                            .background(Color.Burgundy)
                            .cornerRadius(18)
                            .shadow(radius: 10)
                    }
                    .padding(.top, 20)
                }
            }
        }
    }
}

// MARK: - Preview
struct LevelCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LevelCompletedView(
                levelNumber: 10,
                goToMap: .constant(false)
            )
            .environmentObject(GameProgress())
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
