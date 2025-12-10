import SwiftUI

// MARK: - 1. هياكل البيانات ومولّد الأنماط (لم تتغير)
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

// MARK: - 2. عرض النقاط كنمط (لم يتغير)
struct DotPatternView: View {
    let pattern: DotPattern
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 24) {
            ForEach(pattern.columns.indices, id: \.self) { colIndex in
                let dotsCount = pattern.columns[colIndex]
                
                VStack(spacing: 8) {
                    ForEach(0..<dotsCount, id: \.self) { _ in
                        Circle()
                            .fill(Color.Fern)
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

// MARK: - شريط التقدم البكسلي (لم يتغير)
struct PixelProgressBar: View {
    let total: Int
    let filled: Int
    
    var progress: Double {
        Double(filled) / Double(total)
    }
    
    let height: CGFloat = 20
    let width: CGFloat = 200
    let cornerRadius: CGFloat = 5
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.black, lineWidth: 3)
                .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.gray.opacity(0.3)))
                .frame(width: width, height: height)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.Fern)
                .frame(width: width * CGFloat(progress), height: height)
                .animation(.easeOut(duration: 0.5), value: progress)
            
            Text("\(filled) / \(total)")
                .font(.caption.bold())
                .foregroundColor(.black)
                .frame(width: width, height: height, alignment: .center)
        }
    }
}

// MARK: - الزر (لم يتغير)
struct NumberChoiceButton: View {
    let number: Int
    let action: () -> Void
    @Binding var selectedOption: Int?
    let isCorrectAnswer: Int
    let isInteractionDisabled: Bool
    
    var buttonColor: Color {
        if isInteractionDisabled {
            if number == isCorrectAnswer && selectedOption == isCorrectAnswer {
                return Color.Fern
            } else if number == selectedOption {
                return Color.CinnamonWood
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

// MARK: - الكنفيتي (لم يتغير)
struct ConfettiView: View {
    let particles = ["🎉", "✨", "🥳", "🌟", "🎈"]
    var body: some View {
        ZStack {
            ForEach(0..<100, id: \.self) { _ in
                Text(particles.randomElement()!)
                    .font(.system(size: CGFloat.random(in: 15...40)))
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                    .offset(x: CGFloat.random(in: -200...200), y: CGFloat.random(in: -500...300))
                    .scaleEffect(CGFloat.random(in: 0.5...4.5))
                    .opacity(Double.random(in: 0.5...2.0))
                    .modifier(ConfettiAnimationModifier())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.001))
    }
}

struct ConfettiAnimationModifier: ViewModifier {
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 1.0
    
    func body(content: Content) -> some View {
        content
            .offset(offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 3.5)) {
                    offset = CGSize(
                        width: CGFloat.random(in: -200...200),
                        height: CGFloat.random(in: 300...600)
                    )
                    opacity = 0.0
                }
            }
    }
}

// MARK: - 3. صفحة اللعبة الرئيسية مع Navigation
struct InLevelPage: View {
    
    @State private var currentPattern: DotPattern = DotPatternGenerator.randomPattern(for: 5)
    @State private var options: [Int] = []
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isAnswerCorrect = false
    
    @State private var isInteractionDisabled = false
    @State private var selectedOption: Int?
    
    @State private var completedQuestions = 0
    let totalQuestionsInLevel = 5
    
    @State private var ShowConfettie = false  // فقط الكنفيتي
    @State private var goToCompleted = false // ← للتنقل التلقائي
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    
                    PixelProgressBar(total: totalQuestionsInLevel, filled: completedQuestions)
                        .padding(60)
                        .padding(.leading, 70)
                }
                
                VStack {
                    Spacer()
                    
                    ZStack(alignment: .bottomTrailing) {
                        VStack (spacing: 45) {
                            Text(" كم عدد النقاط؟")
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
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.PacificBlue.opacity(0.25))
                                .shadow(radius: 10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.Fern, lineWidth: 5)
                                )
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
                
                if ShowConfettie {
                    ConfettiView()
                        .zIndex(1)
                        .allowsHitTesting(false)
                }
                
                // ← NavigationLink مخفي
                NavigationLink(destination: LevelCompletedView(levelNumber: 1), isActive: $goToCompleted) {
                    EmptyView()
                }
            }
            .onAppear {
                generateNewQuestion(isInitial: true)
            }
            .disabled(isInteractionDisabled)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("إجابه خاطئه"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("اعد المحاوله")) {
                        isInteractionDisabled = false
                        selectedOption = nil
                    }
                )
            }
        }
        .navigationViewStyle(.stack)
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
            
            withAnimation {
                completedQuestions += 1
            }
            
            ShowConfettie = true
            let confettiDuration: Double = 2.5
            
            DispatchQueue.main.asyncAfter(deadline: .now() + confettiDuration) {
                ShowConfettie = false
            }
            
            if completedQuestions >= totalQuestionsInLevel {
                DispatchQueue.main.asyncAfter(deadline: .now() + confettiDuration + 0.5) {
                    goToCompleted = true // ← هنا يروح للصفحة الجديدة
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + confettiDuration + 0.5) {
                    generateNewQuestion()
                }
            }
            
        } else {
            isAnswerCorrect = false
            alertMessage = "للاسف الاجابه خاطئه حاول مره اخرى"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showingAlert = true
            }
        }
    }
}

// MARK: - المعاينة
struct InLevelPage_Previews: PreviewProvider {
    static var previews: some View {
        InLevelPage()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
