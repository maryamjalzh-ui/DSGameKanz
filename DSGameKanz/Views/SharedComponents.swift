import SwiftUI

// MARK: - 1. نموذج النقاط (مشترك بين كل الليفلات)
struct DotPattern {
    let number: Int
    let columns: [Int]
}

// MARK: - 2. عرض النقاط كنمط (مشترك)
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

// MARK: - 3. شريط التقدم البكسلي (مشترك)
struct PixelProgressBar: View {
    let total: Int
    let filled: Int
    
    var progress: Double {
        guard total > 0 else { return 0 }
        return Double(filled) / Double(total)
    }
    
    let height: CGFloat = 20
    let width: CGFloat = 200
    let cornerRadius: CGFloat = 5
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.black, lineWidth: 3)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.gray.opacity(0.3))
                )
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

// MARK: - 4. زر الاختيار (مشترك)
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
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 100, height: 50)
                .background(buttonColor)
                .cornerRadius(15)
                .shadow(radius: 10)
                
            
        }
        .disabled(isInteractionDisabled)
    }
}

// MARK: - 5. الكنفيتي (مشترك)
struct ConfettiView: View {
    let particles = ["🎉", "✨", "🥳", "🌟", "🎈"]
    
    var body: some View {
        ZStack {
            ForEach(0..<100, id: \.self) { _ in
                Text(particles.randomElement()!)
                    .font(.system(size: CGFloat.random(in: 15...40)))
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                    .offset(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -500...300)
                    )
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
