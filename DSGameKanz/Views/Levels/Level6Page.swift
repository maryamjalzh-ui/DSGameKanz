//
//  Level6Page.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 22/06/1447 AH.
//

import SwiftUI

struct Level6Page: View {
    
    // MARK: - State
    
    @State private var totalCount: Int = 0
    @State private var hiddenCount: Int = 0
    @State private var options: [Int] = []
    
    @State private var selectedOption: Int?
    @State private var isCorrect: Bool = false
    
    @State private var completedQuestions = 0
    let totalQuestionsInLevel = 5
    
    @State private var showConfetti = false
    @State private var showAlert = false
    
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
                            
                            Text("كم تبقّى من الكنوز؟")
                                .font(.custom("Farah", size: 50))
                                .foregroundColor(.CinnamonWood)
                                .shadow(radius: 10)
                                .padding(.top, 60)
                                .padding(.leading, 150)
                                .padding(.trailing, 150)
                            
                            // ===== الكنوز =====
                            let visibleCount = totalCount - hiddenCount
                            
                            HStack(spacing: 16) {
                                ForEach(0..<totalCount, id: \.self) { index in
                                    
                                    Image("kanz")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75, height: 75)
                                        // ✅ التظليل Overlay فقط
                                        .overlay(
                                            Group {
                                                if index >= visibleCount {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.black.opacity(0.6))
                                                }
                                            }
                                        )
                                }
                            }
                            
                            // ===== الخيارات =====
                            HStack(spacing: 30) {
                                ForEach(options, id: \.self) { option in
                                    
                                    Button {
                                        handleAnswer(option)
                                    } label: {
                                        Text("\(option)")
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 90, height: 55)
                                            .background(buttonColor(for: option))
                                            .cornerRadius(15)
                                            .shadow(radius: 5)
                                    }
                                    .disabled(selectedOption != nil)
                                }
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
            .onAppear { generateNewQuestion() }
            .alert("حاول مرة أخرى", isPresented: $showAlert) {
                Button("حسنًا") {
                    selectedOption = nil
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Logic
    
    private func generateNewQuestion() {
        
        let total = Int.random(in: 3...6)
        let hidden = Int.random(in: 1..<(total))
        
        let correctAnswer = total - hidden
        
        var optionSet: Set<Int> = [correctAnswer]
        while optionSet.count < 3 {
            optionSet.insert(Int.random(in: 1...6))
        }
        
        totalCount = total
        hiddenCount = hidden
        options = Array(optionSet).shuffled()
        
        selectedOption = nil
        isCorrect = false
    }
    
    
    private func handleAnswer(_ answer: Int) {
        selectedOption = answer
        
        if answer == totalCount - hiddenCount {
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


// MARK: - Preview
struct Level6Page_Previews: PreviewProvider {
    static var previews: some View {
        Level6Page()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
