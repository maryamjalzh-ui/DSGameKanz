import SwiftUI
import UniformTypeIdentifiers

struct Level3Page: View {
    
    let treasureSymbols = ["🌴", "💎", "🪵", "🪙", "🧭", "🏝️"]
    
    @State private var columns: [Int] = []
    @State private var columnSymbols: [Int: String] = [:]
    @State private var dropTargets: [Int] = []
    @State private var solvedColumns: Set<Int> = []
    @State private var correctTargets: Set<Int> = []

    @State private var completedQuestions = 0
    let totalQuestionsInLevel = 5
    
    @State private var showConfetti = false
    @State private var showAlert = false
    @State private var isFullySolved = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // الخلفية Blur
                Image("BluredMap")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // اليدين + الخريطة (HandsOnMap)
                ZStack(alignment: .topLeading) {
                    Image("HandsOnMap")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    // شريط التقدم
                    PixelProgressBar(total: totalQuestionsInLevel, filled: completedQuestions)
                        .padding(60)
                        .padding(.leading, 70)
                }
                
                
                VStack {
                    Spacer()
                    
                    ZStack(alignment: .bottomTrailing) {
                        
                        // الإطار الأخضر الكامل (نفس ليفل 1 و2)
                        VStack(spacing: 10) {
                            
                            Text("اسحب العمود إلى الإجابة الصحيحة")
                                .font(.custom("Farah", size: 50))
                                .foregroundColor(.CinnamonWood)
                                .shadow(radius: 10)
                                .padding(.top, 50)
                                .padding(.trailing, 30)
                                .padding(.leading, 30)

                            // الأعمدة (فوق)
                            // الأعمدة (فوق)
                            // الأعمدة (فوق)
                            HStack(spacing: 50) {
                                ForEach(columns, id: \.self) { value in
                                    
                                    if !solvedColumns.contains(value) {

                                        let symbol = columnSymbols[value] ?? "💎"
                                        
                                        VStack(spacing: 6) {
                                            ForEach(0..<value, id: \.self) { _ in
                                                Text(symbol)
                                                    .font(.system(size: 40))
                                            }
                                        }
                                        .padding(10)
                                        .background(Color.clear)
                                        .id(value)  // ← أهم خطوة حتى يفهم SwiftUI أن العنصر تغير
                                        .transition(.asymmetric(
                                            insertion: .scale.animation(.easeOut(duration: 0.3)),
                                            removal: .scale.animation(.easeIn(duration: 0.3))
                                        ))
                                        .animation(.easeInOut(duration: 0.3), value: solvedColumns)
                                        .onDrag {
                                            NSItemProvider(object: "\(value)" as NSString)
                                        }
                                    }
                                }
                            }

                            
                            // الأرقام (تحت)
                            // الأرقام (تحت)
                            HStack(spacing: 40) {
                                ForEach(dropTargets, id: \.self) { option in
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(correctTargets.contains(option) ? Color.Fern : Color.Burgundy)
                                            .frame(width: 100, height: 60)
                                            .shadow(radius: 6)
                                        
                                        Text("\(option)")
                                            .font(.system(size: 34, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .onDrop(of: [.plainText], isTargeted: nil) { providers in
                                        handleDrop(providers: providers, target: option)
                                    }
                                }
                            }
                            .padding(.bottom, 40)

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
                        .frame(maxWidth: 700)
                        .padding(.horizontal, 50)
                        
                        
                        // الشخصية تحت يمين الإطار — مثل ليفل 1
                        Image(isFullySolved ? "happy" : "thinking")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .shadow(radius: 5)
                            .offset(x: -90, y: 50)
                    }
                    
                    Spacer()
                }
                
                
                // كونفيتي
                if showConfetti {
                    ConfettiView()
                        .zIndex(20)
                }
            }
            .onAppear { generateNewPuzzle() }
            .alert("إجابة خاطئة", isPresented: $showAlert) {
                Button("إعادة المحاولة") {}
            }
        }
        .navigationViewStyle(.stack)
    }
    
    
    // MARK: - Logic
    
    private func generateNewPuzzle() {
        
        let possible = [2, 3, 4, 5, 6]
        
        columns = Array(possible.shuffled().prefix(3)).sorted()
        solvedColumns.removeAll()
        isFullySolved = false
        
        var mapping: [Int: String] = [:]
        var symbols = treasureSymbols.shuffled()
        
        for v in columns {
            mapping[v] = symbols.removeFirst()
        }
        
        columnSymbols = mapping
        dropTargets = columns.shuffled()
    }
    
    
    private func handleDrop(providers: [NSItemProvider], target: Int) -> Bool {
        
        guard let provider = providers.first else { return false }
        
        provider.loadObject(ofClass: NSString.self) { object, _ in
            
            guard let ns = object as? NSString else { return }
            guard let draggedValue = Int(ns as String) else { return }
            
            DispatchQueue.main.async {
                
                if draggedValue == target {
                    
                    solvedColumns.insert(target)
                    correctTargets.insert(target)  // ← تلوين الزر
                    
                    withAnimation {
                        solvedColumns.insert(draggedValue) // ← يخفي العمود
                    }
                    
                    if solvedColumns.count == columns.count {
                        
                        isFullySolved = true
                        completedQuestions += 1
                        showConfetti = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showConfetti = false
                            
                            if completedQuestions < totalQuestionsInLevel {
                                correctTargets.removeAll()
                                generateNewPuzzle()
                            }
                        }
                    }
                    
                } else {
                    showAlert = true
                }

            }
        }
        
        return true
    }
}


// MARK: - Preview
struct Level3Page_Previews: PreviewProvider {
    static var previews: some View {
        Level3Page()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
