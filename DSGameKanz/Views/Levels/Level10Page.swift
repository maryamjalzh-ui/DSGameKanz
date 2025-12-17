//
//  Level10Page.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 22/06/1447 AH.
//

import SwiftUI

struct Level10Page: View {
    
    // ✅ (1) ربط التقدم
    @EnvironmentObject var progress: GameProgress
    @EnvironmentObject var languageManager: LanguageManager

    // MARK: - State
    
    let treasureEmojis = ["🗺️", "⚓️", "🛶", "🗝️", "📜"]
    
    @State private var rightCount = 0
    @State private var leftCount = 0
    
    @State private var currentEmoji = "🗺️"
    
    @State private var options: [Int] = []
    @State private var correctAnswer = 0
    
    @State private var selectedOption: Int? = nil
    @State private var isCorrect = false
    @State private var shakeTrigger: Int = 0
    
    @State private var completedQuestions = 0
    let totalQuestionsInLevel = 5
    
    @State private var showConfetti = false
    
    // ✅ (2) الانتقالات
    @State private var goToCompletedLevel = false
    @State private var goToMap = false   // 👈 الجديد
    
    
    // MARK: - UI
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // 🔹 صفحة الإكمال
                NavigationLink(
                    destination: LevelCompletedView(
                        levelNumber: 10,
                        goToMap: $goToMap
                    )
                    .environmentObject(progress),
                    isActive: $goToCompletedLevel
                ) {
                    EmptyView()
                }
                
                // 🔹 الرجوع الفعلي للخريطة
                NavigationLink(
                    destination: RoadMap()
                        .environmentObject(progress),
                    isActive: $goToMap
                ) {
                    EmptyView()
                }
                
                Image("BluredMap")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ZStack(alignment: .topLeading) {
                    Image("HandsOnMap")
                        .resizable()
                        .scaledToFit()
                        .padding()
                    
                    PixelProgressBar(
                        total: totalQuestionsInLevel,
                        filled: completedQuestions
                    )
                    .padding(60)
                    .padding(.leading, 70)
                }
                
                VStack {
                    Spacer()
                    
                    ZStack(alignment: .bottomTrailing) {
                        
                        VStack(spacing: 40) {
                            
                            HStack(spacing: 16) {
                                
                                Button {
                                    BackgroundMusicManager.shared.playVoiceOver("finallevelsvoiceovers")
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.CinnamonWood)
                                        .shadow(radius: 10)
                                }
                                .accessibilityLabel("تشغيل صوت السؤال")
                                
                                Text(languageManager.isArabic
                                                                 ?"إختر الإجابة الصحيحة" : "Choose the correct answer.")
                                    .font(.custom("Farah", size: 50))
                                    .foregroundColor(.CinnamonWood)
                                    .shadow(radius: 10)
                            }
                            .padding(.top, 60)
                            .padding(.horizontal, 60)
                            
                            HStack(spacing: 40) {
                                emojiGroup(count: rightCount)
                                
                                Text("−")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.CinnamonWood)
                                
                                emojiGroup(count: leftCount)
                            }
                            .environment(\.layoutDirection, .rightToLeft)
                            
                            Divider().frame(width: 400)
                            
                            HStack(spacing: 30) {
                                ForEach(options, id: \.self) { option in
                                    
                                    Button {
                                        handleAnswer(option)
                                    } label: {
                                        emojiGroup(count: option)
                                            .padding(14)
                                            .background(buttonColor(for: option))
                                            .cornerRadius(18)
                                            .shadow(radius: 5)
                                    }
                                    .modifier(
                                        ShakeEffect(
                                            trigger: selectedOption == option && !isCorrect
                                            ? shakeTrigger
                                            : 0
                                        )
                                    )
                                    .disabled(selectedOption != nil && isCorrect)
                                }
                            }
                            .padding(.bottom, 40)
                        }
                        .background(
                            ZStack {
                                LinearGradient(
                                    colors: [Color.Fern.opacity(0.18), Color.clear],
                                    startPoint: .trailing,
                                    endPoint: .leading
                                )
                                .cornerRadius(25)
                                
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.PacificBlue.opacity(0.25))
                                
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.Fern, lineWidth: 5)
                            }
                            .shadow(radius: 10)
                        )
                        .frame(maxWidth: 600)
                        .padding(.horizontal, 50)
                        
                        Image(isCorrect ? "happy" : "thinking")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .offset(x: -90, y: 50)
                    }
                    
                    Spacer()
                }
                
                if showConfetti {
                    ConfettiView().zIndex(20)
                }
            }
            .onAppear { generateNewQuestion() }
            .onAppear {
                BackgroundMusicManager.shared.playVoiceOver("finallevelsvoiceovers")
            }
        }
        .navigationViewStyle(.stack)
    }
    
    
    // MARK: - Components
    
    private func emojiGroup(count: Int) -> some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { _ in
                Text(currentEmoji)
                    .font(.system(size: 36))
            }
        }
    }
    
    
    // MARK: - Logic
    
    private func generateNewQuestion() {
        let big = Int.random(in: 2...3)
        let small = Int.random(in: 1..<big)
        
        rightCount = big
        leftCount = small
        correctAnswer = big - small
        
        var set: Set<Int> = [correctAnswer]
        while set.count < 2 {
            set.insert(Int.random(in: 1...3))
        }
        
        options = Array(set).shuffled()
        selectedOption = nil
        isCorrect = false
        
        currentEmoji = treasureEmojis[completedQuestions % treasureEmojis.count]
    }
    
    
    private func handleAnswer(_ answer: Int) {
        selectedOption = answer
        
        if answer == correctAnswer {
            isCorrect = true
            completedQuestions += 1
            showConfetti = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showConfetti = false
                if completedQuestions < totalQuestionsInLevel {
                    generateNewQuestion()
                } else {
                    // ✅ نهاية آخر ليفل
                    goToCompletedLevel = true
                }
            }
        } else {
            shakeTrigger += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                selectedOption = nil
            }
        }
    }
    
    
    private func buttonColor(for option: Int) -> Color {
        guard let selected = selectedOption else {
            return Color.Burgundy
        }
        
        if option == selected && isCorrect {
            return Color.Fern
        }
        
        if option == selected && !isCorrect {
            return Color.CinnamonWood
        }
        
        return Color.Burgundy
    }
}


// MARK: - Shake Effect

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var trigger: Int
    
    var animatableData: CGFloat {
        get { CGFloat(trigger) }
        set { }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX:
                    amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                y: 0
            )
        )
    }
}


// MARK: - Preview

struct Level10Page_Previews: PreviewProvider {
    static var previews: some View {
        Level10Page()
            .environmentObject(LanguageManager()) 
            .environmentObject(GameProgress())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
