
//
//  inLevelPage.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani
//


import SwiftUI

// MARK: - مولّد الأنماط للمستوى الأول (سهل)
struct DotPatternGeneratorLevel1 {
    static let templates: [Int: [[Int]]] = [
        3: [[3], [2, 1]],
        4: [[4], [2, 2]],
        5: [[5], [3, 2]],
        6: [[5, 1], [3, 3]],
        7: [[5, 2], [4, 3], [3, 2, 2]],
        8: [[5, 3], [4, 4], [3, 3, 2]],
        9: [[5, 4], [3, 3, 3]]
    ]
    
    static var supportedNumbers: [Int] {
        Array(templates.keys).sorted()
    }
    
    static func randomPattern(for number: Int) -> DotPattern {
        let options = templates[number] ?? [[number]]
        let columns = options.randomElement() ?? [number]
        return DotPattern(number: number, columns: columns)
    }
    
    static func randomPatternInSupportedRange() -> DotPattern {
        let nums = supportedNumbers
        return randomPattern(for: nums.randomElement() ?? 5)
    }
    
    static func generateQuestion() -> (pattern: DotPattern, options: [Int]) {
        let newPattern = randomPatternInSupportedRange()
        var optionsSet = Set<Int>([newPattern.number])
        
        while optionsSet.count < 3 {
            if let random = supportedNumbers.randomElement() {
                optionsSet.insert(random)
            }
        }
        
        return (newPattern, Array(optionsSet).shuffled())
    }
}

// MARK: - صفحة المستوى الأول
struct InLevelPage: View {
    
    @EnvironmentObject var progress: GameProgress
    
    @State private var currentPattern: DotPattern = DotPatternGeneratorLevel1.randomPattern(for: 5)
    @State private var options: [Int] = []
    
    @State private var isAnswerCorrect = false
    @State private var isInteractionDisabled = false
    @State private var selectedOption: Int?
    
    @State private var completedQuestions = 0
    let totalQuestionsInLevel = 5
    
    @State private var showConfetti = false
    
    // 🔹 للانتقال
    @State private var goToCompletedLevel = false
    @State private var goToMap = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // 🔹 الانتقال لصفحة الإكمال
                NavigationLink(
                    destination: LevelCompletedView(
                        levelNumber: 1,
                        goToMap: $goToMap
                    )
                    .environmentObject(progress),
                    isActive: $goToCompletedLevel
                ) {
                    EmptyView()
                }
                
                // 🔹 الرجوع الفعلي للرود ماب
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
                        .frame(maxWidth: .infinity)
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
                        VStack (spacing: 45) {
                            
                            HStack(spacing: 16) {
                                Button {
                                    BackgroundMusicManager.shared.playVoiceOver("level1voiceover")
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.CinnamonWood)
                                }
                                .accessibilityLabel("تشغيل صوت السؤال")

                                Text("كم عدد النقاط؟")
                            }
                            .font(.custom("Farah", size: 50))
                            .shadow(radius: 10)
                            .foregroundColor(.CinnamonWood)
                            .padding(.top, 50)
                            
                            DotPatternView(pattern: currentPattern)
                                .padding(.vertical, 10)
                            
                            HStack(spacing: 15) {
                                ForEach(options, id: \.self) { option in
                                    NumberChoiceButton(
                                        number: option,
                                        
                                        action: { handleAnswer(option) },
                                        selectedOption: $selectedOption,
                                        isCorrectAnswer: currentPattern.number,
                                        isInteractionDisabled: isInteractionDisabled
                                        
                                    )
                                }
                            }
                            .padding(.horizontal, 40)
                            .padding(.bottom, 60)
                        }
                        .background(
                            ZStack {
                                LinearGradient(
                                    colors: [
                                        Color.Fern.opacity(0.18),
                                        Color.clear
                                    ],
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
                        
                        Image(isInteractionDisabled && isAnswerCorrect ? "happy" : "thinking")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .shadow(radius: 5)
                            .offset(x: -20, y: 50)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
                
                if showConfetti {
                    ConfettiView()
                        .zIndex(1)
                        .allowsHitTesting(false)
                }
            }
            .onAppear {
                BackgroundMusicManager.shared.playVoiceOver("level1voiceover")
                generateNewQuestion()
            }
            .disabled(isInteractionDisabled)
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - منطق اللعبة
    private func generateNewQuestion() {
        let (newPattern, newOptions) = DotPatternGeneratorLevel1.generateQuestion()
        currentPattern = newPattern
        options = newOptions
        isInteractionDisabled = false
        selectedOption = nil
    }
    
    private func handleAnswer(_ answer: Int) {
        isInteractionDisabled = true
        selectedOption = answer
        
        if answer == currentPattern.number {
            isAnswerCorrect = true
            withAnimation {
                completedQuestions += 1
            }
            
            showConfetti = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showConfetti = false
                
                if completedQuestions < totalQuestionsInLevel {
                    generateNewQuestion()
                } else {
                    goToCompletedLevel = true
                }
            }
            
        } else {
            // ❌ خطأ → لون فقط ثم رجوع
            isAnswerCorrect = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isInteractionDisabled = false
                selectedOption = nil
            }
        }
    }
}

// MARK: - Preview
struct InLevelPage_Previews: PreviewProvider {
    static var previews: some View {
        InLevelPage()
            .environmentObject(GameProgress())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
