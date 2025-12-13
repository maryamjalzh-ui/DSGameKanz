
//
//  Level8Page.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani
//

//
//  Level8Page.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani
//

import SwiftUI

struct Level8Page: View {
    
    // MARK: - State
    
    @State private var leftCount: Int = 0
    @State private var rightCount: Int = 0
    
    @State private var leftEmoji: String = "🏝️"
    @State private var rightEmoji: String = "🗺️"
    
    @State private var correctAnswer: Bool = false   // true = متساويتان
    @State private var selectedAnswer: Bool? = nil
    @State private var isCorrect: Bool = false
    
    @State private var completedQuestions = 0
    let totalQuestionsInLevel = 5
    
    @State private var showConfetti = false
    @State private var showAlert = false
    
    // MARK: - Emoji Sets (Treasure Hunt vibe)
    
    let emojiSets: [String] = ["🏝️", "🗝️", "💰", "💎", "🗺️"]
    
    
    // MARK: - UI
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // الخلفية
                Image("BluredMap")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // الخريطة + شريط التقدم
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
                            
                            // العنوان
                            Text("هل المجموعتان متساويتان؟")
                                .font(.custom("Farah", size: 50))
                                .foregroundColor(.CinnamonWood)
                                .shadow(radius: 10)
                                .padding(.top, 60)
                                .padding(.horizontal, 150)
                            
                            
                            // ===== المجموعات =====
                            HStack(spacing: 80) {
                                
                                // المجموعة اليسرى
                                VStack(spacing: 10) {
                                    ForEach(0..<leftCount, id: \.self) { _ in
                                        Text(leftEmoji)
                                            .font(.system(size: 44))
                                    }
                                }
                                
                                // المجموعة اليمنى
                                VStack(spacing: 10) {
                                    ForEach(0..<rightCount, id: \.self) { _ in
                                        Text(rightEmoji)
                                            .font(.system(size: 44))
                                    }
                                }
                            }
                            
                            
                            // ===== أزرار نعم / لا =====
                            HStack(spacing: 40) {
                                
                                // زر نعم
                                Button {
                                    handleAnswer(true)
                                } label: {
                                    Text("نعم")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 120, height: 60)
                                        .background(buttonColor(for: true))
                                        .cornerRadius(16)
                                        .shadow(radius: 5)
                                }
                                .disabled(selectedAnswer != nil)
                                
                                
                                // زر لا
                                Button {
                                    handleAnswer(false)
                                } label: {
                                    Text("لا")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 120, height: 60)
                                        .background(buttonColor(for: false))
                                        .cornerRadius(16)
                                        .shadow(radius: 5)
                                }
                                .disabled(selectedAnswer != nil)
                            }
                            .padding(.bottom, 40)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.PacificBlue.opacity(0.25))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.Fern, lineWidth: 5)
                                )
                                .shadow(radius: 10)
                        )
                        .frame(maxWidth: 700)
                        .padding(.horizontal, 50)
                        
                        
                        // الشخصية
                        Image(isCorrect ? "happy" : "thinking")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .offset(x: -90, y: 50)
                    }
                    
                    Spacer()
                }
                
                // الكونفيتي
                if showConfetti {
                    ConfettiView().zIndex(20)
                }
            }
            .onAppear {
                generateNewQuestion()
            }
            .alert("حاول مرة أخرى", isPresented: $showAlert) {
                Button("حسنًا") {
                    selectedAnswer = nil
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    
    // MARK: - Logic
    
    private func generateNewQuestion() {
        
        let emojiPool = emojiSets.shuffled()
        leftEmoji = emojiPool[0]
        rightEmoji = emojiPool[1]
        
        let equal = Bool.random()
        
        if equal {
            let value = Int.random(in: 2...5)
            leftCount = value
            rightCount = value
        } else {
            leftCount = Int.random(in: 2...5)
            repeat {
                rightCount = Int.random(in: 2...5)
            } while rightCount == leftCount
        }
        
        correctAnswer = equal
        selectedAnswer = nil
        isCorrect = false
    }
    
    
    private func handleAnswer(_ answer: Bool) {
        selectedAnswer = answer
        
        if answer == correctAnswer {
            isCorrect = true
            completedQuestions += 1
            showConfetti = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showConfetti = false
                if completedQuestions < totalQuestionsInLevel {
                    generateNewQuestion()
                }
            }
        } else {
            showAlert = true
        }
    }
    
    
    private func buttonColor(for value: Bool) -> Color {
        guard let selected = selectedAnswer else {
            return Color.Burgundy
        }
        
        if selected == value && isCorrect {
            return Color.Fern        // ✅ الزر الصحيح يتلوّن أخضر
        }
        
        if selected == value && !isCorrect {
            return Color.CinnamonWood
        }
        
        return Color.Burgundy
    }
}


// MARK: - Preview
struct Level8Page_Previews: PreviewProvider {
    static var previews: some View {
        Level8Page()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
