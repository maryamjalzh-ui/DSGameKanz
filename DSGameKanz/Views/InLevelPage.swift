import SwiftUI

// MARK: - 1. هياكل البيانات ومولّد الأنماط
struct DotPattern {
    let number: Int
    let columns: [Int]
}

struct DotPatternGenerator {
    static let templates: [Int: [[Int]]] = [
        3: [[3], [2, 1]], 4: [[4], [2, 2]], 5: [[5], [3, 2]],
        6: [[5, 1], [3, 3]], 7: [[5, 2], [4, 3], [3, 2, 2]],
        8: [[5, 3], [4, 4], [3, 3, 2]], 9: [[5, 4], [3, 3, 3]]
    ]
    
    static var supportedNumbers: [Int] {
        Array(templates.keys).sorted()
    }
    
    static func randomPattern(for number: Int) -> DotPattern {
        let options = templates[number] ?? [[number]]
        let columns = options.randomElement() ?? [number]
        return DotPattern(number: number, columns: columns)
    }
    
    static func generateQuestion() -> (pattern: DotPattern, options: [Int]) {
        let newPattern = randomPatternInSupportedRange()
        var optionsSet = Set<Int>()
        optionsSet.insert(newPattern.number)
        
        let numbers = supportedNumbers
        while optionsSet.count < 3 {
            if let random = numbers.randomElement() {
                optionsSet.insert(random)
            }
        }
        
        let options = Array(optionsSet).shuffled()
        return (pattern: newPattern, options: options)
    }
    
    static func randomPatternInSupportedRange() -> DotPattern {
        let nums = supportedNumbers
        let randomNumber = nums.randomElement() ?? 5
        return randomPattern(for: randomNumber)
    }
}

// MARK: - 2. عرض النقاط كنمط
struct DotPatternView: View {
    let pattern: DotPattern
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 24) {
            ForEach(pattern.columns.indices, id: \.self) { colIndex in
                let dotsCount = pattern.columns[colIndex]
                
                VStack(spacing: 8) {
                    ForEach(0..<dotsCount, id: \.self) { _ in
                        Circle()
                            .fill(Color.red)
                            .frame(width: 28, height: 28)
                            .shadow(radius: 1)
                    }
                }
            }
        }
        .padding()
        .frame(minHeight: 150)
    }
}

// MARK: - 3. صفحة اللعبة الرئيسية (InLevelPage)
struct InLevelPage: View {
    
    // إضافة وسيط بسيط لإبلاغ الجذر باكتمال المستوى
    var onLevelCompleted: (() -> Void)? = nil
    
    @State private var currentPattern: DotPattern = DotPatternGenerator.randomPattern(for: 5)
    @State private var options: [Int] = []
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isAnswerCorrect = false
    
    @State private var isInteractionDisabled = false
    @State private var selectedOption: Int?
    
    @State private var completedQuestions = 0
    let totalQuestionsInLevel = 5
    
    @State private var isLevelCompleted = false
    @State private var showingLevelCompletedSheet = false // متغير النافذة الجديدة
    
    var body: some View {
        ZStack {
            Image("BluredMap")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("HandsOnMap")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 1000)
                    .overlay(
                        VStack(spacing: 3) {
                            Text("المرحلة الأولى")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.top, 40)
                            
                            Text("السؤال \(completedQuestions + 1) / \(totalQuestionsInLevel)")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 300, height: 70)
                                .background(Color(red: 0.55, green: 0.1, blue: 0.15))
                                .cornerRadius(15)
                            
                            Text("كم عدد النقاط؟")
                                .font(.title3)
                                .foregroundColor(.black)
                            
                            DotPatternView(pattern: currentPattern)
                                .padding(.vertical, 5)
                            
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
                            
                            Spacer()
                        }
                        .padding(.top, 100)
                    )
                
                Spacer()
            }
        }
        .onAppear {
            generateNewQuestion(isInitial: true)
        }
        .disabled(isInteractionDisabled)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(isAnswerCorrect ? "إجابة صحيحة! 🎉" : "إجابة خاطئة! 😔"),
                message: Text(alertMessage),
                dismissButton: .default(Text("التالي")) {
                    generateNewQuestion()
                }
            )
        }
        .sheet(isPresented: $showingLevelCompletedSheet) {
            VStack(spacing: 30) {
                Text("🎉 تهانينا! أكملت المستوى! 🎉")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                // زر العودة للخريطة
                Button {
                    // إغلاق الـ sheet ثم إبلاغ الجذر للرجوع للخريطة
                    showingLevelCompletedSheet = false
                    onLevelCompleted?()
                } label: {
                    Text("العودة إلى الخريطة")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 250, height: 50)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
            }
            .padding()
        }

    }
    
    // MARK: - منطق اللعبة
    private func generateNewQuestion(isInitial: Bool = false) {
        let (newPattern, newOptions) = DotPatternGenerator.generateQuestion()
        currentPattern = newPattern
        options = newOptions
        isInteractionDisabled = false
        selectedOption = nil
        showingAlert = false
    }
    
    private func handleAnswer(_ answer: Int) {
        isInteractionDisabled = true
        selectedOption = answer
        
        if answer == currentPattern.number {
            isAnswerCorrect = true
            alertMessage = "أحسنت! الإجابة صحيحة."
            completedQuestions += 1
        } else {
            isAnswerCorrect = false
            alertMessage = "للأسف، الإجابة خاطئة. الإجابة الصحيحة هي: \(currentPattern.number)."
        }
        
        if completedQuestions >= totalQuestionsInLevel {
            showingLevelCompletedSheet = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showingAlert = true
            }
        }
    }
}

// MARK: - مكون الزر
struct NumberChoiceButton: View {
    let number: Int
    let action: () -> Void
    @Binding var selectedOption: Int?
    let isCorrectAnswer: Int
    let isInteractionDisabled: Bool
    
    var buttonColor: Color {
        if isInteractionDisabled {
            if number == isCorrectAnswer {
                return Color(red: 0.2, green: 0.5, blue: 0.25)
            } else if number == selectedOption {
                return Color.red
            }
        }
        return Color(red: 0.55, green: 0.1, blue: 0.15)
    }
    
    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 100, height: 50)
                .background(buttonColor)
                .cornerRadius(15)
        }
        .disabled(isInteractionDisabled)
    }
}

// MARK: - المعاينة
struct InLevelPage_Previews: PreviewProvider {
    static var previews: some View {
        InLevelPage()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
