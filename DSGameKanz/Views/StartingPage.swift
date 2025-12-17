import SwiftUI

struct StartingPage: View {

    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color.primary.ignoresSafeArea()

                // Background image
                Image("Start")
                    .resizable()
                    .ignoresSafeArea()
                    .allowsHitTesting(false) // ✅ never blocks taps

                // ===== TITLE TEXT (keeps bilingual feature + shadow) =====
                VStack(alignment: .center, spacing: 8) {
                    Text(languageManager.isArabic
                         ? "هل انت مستعد لمساعدتي"
                         : "Are you ready to help")

                    Text(languageManager.isArabic
                         ? "في ايجاد اصدقائي"
                         : "me find my friends?")
                }
                .font(.custom("Farah", size: 60))
                .padding(.top, -220)
                .padding(.leading, -480)
                .foregroundColor(.Burgundy)
                .shadow(radius: 10)

                // ===== START BUTTON (reliable navigation + shadow) =====
                VStack {
                    Spacer().frame(height: 280)

                    NavigationLink(destination: CharacterChoice()) {
                        Text(languageManager.isArabic ? "ابدأ رحلتك" : "Start")
                            .font(.custom("Farah", size: 50))
                            .foregroundColor(.white)
                            .padding(.vertical, 18)
                            .padding(.horizontal, languageManager.isArabic ? 40 : 60)
                            .background(Color.Burgundy)
                            .cornerRadius(35)
                            .shadow(radius: 10)
                    }
                    .padding(.top, -200)
                    .padding(.leading, languageManager.isArabic ? -430 : -380)
                }

                // ===== LANGUAGE SWITCH BUTTON (kept) =====
                VStack {
                    HStack {
                        Spacer()

                        Button {
                            languageManager.toggle()
                        } label: {
                            Text(languageManager.isArabic ? "English" : "العربية")
                                .font(.custom("Farah", size: 26))
                                .foregroundColor(.white)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 8)
                                .background(Color.Burgundy.opacity(0.7))
                                .cornerRadius(14)
                        }
                        .padding(.trailing, 45)
                        .padding(.top, 950)
                    }
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)

            // ✅ kept BOTH features: background music + delayed voice over
            .onAppear {
                BackgroundMusicManager.shared.startMusic()

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    BackgroundMusicManager.shared.playVoiceOver("firstpagevoiceover")
                }
            }
        }
    }
}

struct StartingPage_Previews: PreviewProvider {
    static var previews: some View {
        StartingPage()
            .environmentObject(LanguageManager()) // ✅ so preview won’t crash
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
