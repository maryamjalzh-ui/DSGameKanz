import SwiftUI
import UniformTypeIdentifiers

struct Level4Page: View {
    
    @State private var columns: [Int] = []
    @State private var selectedIndex: Int = 0
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    @State private var bounce: Bool = false
    
    @State private var completedQuestions = 0
    let totalQuestionsInLevel = 5
    
    @State private var showConfetti = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // الخلفية
                Image("BluredMap")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // اليد + الخريطة
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
                    // 🔹 إندكيشن البداية (يمين)
           

                    ZStack(alignment: .bottomTrailing) {
                        
                        VStack(spacing: 50) {
                            
                            Text("هل تسjطيع ترتيب الكنوز من الأكبر إلى الأصغر؟")
                                .font(.custom("Farah", size: 50))
                                .foregroundColor(.CinnamonWood)
                                .shadow(radius: 10)
                                .padding(.top, 50)
                                .padding(.horizontal, 50)
                            
                            
                            // ======== الأعمدة ========
                            HStack(spacing: 50) {
                                ForEach(columns.indices, id: \.self) { index in
                                    
                                    let count = columns[index]
                                    let isSelected = (selectedIndex == index)
                                    
                                    
                                    ZStack {
                                        VStack(spacing: 5) {
                                            ForEach(0..<count, id: \.self) { _ in
                                                Image("kanz")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 50, height: 50)
                                            }
                                        }
                                        .environment(\.layoutDirection, .rightToLeft)
                                        .padding(6)
                                        .id(columns[index])
                                        
                                        // حركة العمود المختار فقط
                                        .offset(
                                            x: isSelected ? dragOffset : 0,
                                            y: isSelected && !isDragging
                                                ? (bounce ? -4 : 4)
                                                : 0
                                        )
                                        
                                        .scaleEffect(isSelected ? 1.06 : 1.0)
                                        .shadow(
                                            color: isSelected ? Color.Burgundy.opacity(0.8) : .clear,
                                            radius: isSelected ? 12 : 0
                                        )
                                    }
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                selectedIndex = index
                                                isDragging = true
                                                dragOffset = value.translation.width
                                            }
                                            .onEnded { value in
                                                handleDragEnd(translation: value.translation.width)
                                            }
                                    )
                                    .onTapGesture {
                                        selectedIndex = index
                                    }
                                }
                            }
                            .animation(.none, value: columns)
                            
                        }
                        .background(
                            ZStack {
                                // التدرج (إندكيشن من اليمين)
                                LinearGradient(
                                    colors: [
                                        Color.Fern.opacity(0.18),
                                        Color.clear
                                    ],
                                    startPoint: .trailing,   // 👈 من اليمين
                                    endPoint: .leading
                                )
                                .cornerRadius(25)
                                
                                // الخلفية الأساسية
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.PacificBlue.opacity(0.25))
                                
                                // الإطار الأخضر
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.Fern, lineWidth: 5)
                            }
                            .shadow(radius: 10)
                        )

                        
                        .frame(maxWidth: 700)
                        .padding(.horizontal, 50)
                        
                        
                        // الشخصية
                        Image(isSortedCorrectly() ? "happy" : "thinking")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .offset(x: -90, y: 50)
                    }
                    
                    Spacer()
                }
                
                
                // الكونفيتي
                if showConfetti {
                    ConfettiView()
                        .zIndex(20)
                }
            }
            .onAppear {
                startBounce()
                generateNewPuzzle()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    
    // MARK: - Logic
    
    private func startBounce() {
        withAnimation(
            .easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true)
        ) {
            bounce.toggle()
        }
    }
    
    
    private func generateNewPuzzle() {
        
        let possible = [1, 2, 3, 4]
        
        var current: [Int] = []
        var wrongIndex = 0
        
        repeat {
            // نختار 3 قيم عشوائية
            let picked = Array(possible.shuffled().prefix(3))
            
            // الترتيب الصحيح: من الأكبر إلى الأصغر
            let correct = picked.sorted(by: >)
            current = correct
            
            // نخرب الترتيب بسواب واحد
            let i = Int.random(in: 0..<current.count)
            var j = Int.random(in: 0..<current.count)
            while j == i {
                j = Int.random(in: 0..<current.count)
            }
            
            current.swapAt(i, j)
            wrongIndex = i
            
            columns = current
            
        } while isSortedCorrectly()   // 🔒 نضمن أنه غير محلول
        
        selectedIndex = wrongIndex    // العمود الغلط هو المختار
        dragOffset = 0
        isDragging = false
    }


    
    private func handleDragEnd(translation: CGFloat) {
        let threshold: CGFloat = 80
        var newIndex = selectedIndex
        
        if translation > threshold && selectedIndex < columns.count - 1 {
            withAnimation(.easeInOut(duration: 0.25)) {
                columns.swapAt(selectedIndex, selectedIndex + 1)
                newIndex = selectedIndex + 1
            }
        }
        else if translation < -threshold && selectedIndex > 0 {
            withAnimation(.easeInOut(duration: 0.25)) {
                columns.swapAt(selectedIndex, selectedIndex - 1)
                newIndex = selectedIndex - 1
            }
        }
        
        selectedIndex = newIndex
        
        withAnimation(.spring()) {
            dragOffset = 0
        }
        
        isDragging = false
        checkCompletion()
    }
    
    
    private func checkCompletion() {
        if isSortedCorrectly() {
            completedQuestions += 1
            showConfetti = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showConfetti = false
                if completedQuestions < totalQuestionsInLevel {
                    generateNewPuzzle()
                }
            }
        }
    }
    
    
    private func isSortedCorrectly() -> Bool {
        Array(columns.reversed()) == columns.sorted(by: >)
    }

}


// MARK: - Preview
struct Level4Page_Previews: PreviewProvider {
    static var previews: some View {
        Level4Page()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

