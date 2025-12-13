import SwiftUI

struct LevelCompletedView: View {

    let levelNumber: Int
    @Binding var goToMap: Bool   // 👈 الجديد

    @EnvironmentObject var progress: GameProgress

    // MARK: - Character Logic
    var unlockedCharacterImageName: String? {
        // تظهر كل ليفلين (2، 4، 6، 8، 10)
        guard levelNumber % 2 == 0 else { return nil }
        return "level \(levelNumber)-happy"
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

                VStack(spacing: 20) {

                    Text("أحسنت!")
                        .font(.custom("Farah", size: 50))
                        .foregroundColor(.CinnamonWood)

                    if let imageName = unlockedCharacterImageName {
                        Text("لقد حصلت على صديق جديد")
                            .font(.custom("Farah", size: 30))
                            .foregroundColor(.black.opacity(0.7))

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
                levelNumber: 2,
                goToMap: .constant(false)   // ✅ حل البرفيو
            )
            .environmentObject(GameProgress())
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
