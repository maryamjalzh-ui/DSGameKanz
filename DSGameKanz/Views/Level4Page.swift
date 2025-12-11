//
//  Level4Page.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 20/06/1447 AH.
//
import SwiftUI
import UniformTypeIdentifiers

struct Level4Page: View {
    
    @State private var columns: [Int] = []
    @State private var selectedIndex: Int = 0
    @State private var bouncingOffset: CGFloat = -4
    
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
                    
                    PixelProgressBar(total: totalQuestionsInLevel, filled: completedQuestions)
                        .padding(60)
                        .padding(.leading, 70)
                }
                
                
                VStack {
                    Spacer()
                    
                    ZStack(alignment: .bottomTrailing) {
                        
                        VStack(spacing: 50) {
                            
                            Text("رتّب الكنز  من الأصغر إلى الأكبر")
                                .font(.custom("Farah", size: 50))
                                .foregroundColor(.CinnamonWood)
                                .shadow(radius: 10)
                                .padding(.top, 50)
                                .padding(.leading, 50)
                                .padding(.trailing, 50)
                            
                            
                            // ======== الأعمدة ========
                            HStack(spacing: 50) {
                                ForEach(columns.indices, id: \.self) { index in
                                    
                                    let count = columns[index]
                                    
                                    ZStack {
                                        VStack(spacing: 5) {
                                            ForEach(0..<count, id: \.self) { _ in
                                                Image("kanz")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 40, height: 40)
                                            }
                                        }
                                        .padding(6)
                                        .id(columns[index])   // يثبت هوية العمود ويمنع الوميض/القص
                                        
                                        // ✨ الحركة (bounce) للعمود المُختار فقط
                                        .offset(y: selectedIndex == index ? bouncingOffset : 0)
                                        .animation(
                                            selectedIndex == index
                                            ? .easeInOut(duration: 0.6).repeatForever(autoreverses: true)
                                            : .easeOut(duration: 0.1),   // ← يوقف القديم فوراً
                                            value: selectedIndex == index   // ← أهم سطر!
                                        )

                                        
                                        // ✨ تأثير التحديد (تكبير + ظل)
                                        .scaleEffect(selectedIndex == index ? 1.06 : 1.0)
                                        .shadow(color: selectedIndex == index ? Color.Burgundy.opacity(0.8) : .clear,
                                                radius: selectedIndex == index ? 12 : 0)
                                        .animation(.easeInOut(duration: 0.25), value: selectedIndex)
                                    }
                                    .onTapGesture {
                                        selectedIndex = index
                                    }
                                }
                            }
                            .animation(.none, value: columns)   // يمنع أنميشن غريب وقت السواب
                            .padding(.top, 20)
                            
                            
                            // ======== الأسهم ========
                            HStack(spacing: 40) {
                                
                                Button {
                                    moveLeft()
                                } label: {
                                    Image(systemName: "arrow.left.circle.fill")
                                        .font(.system(size: 55))
                                        .foregroundColor(.Burgundy)
                                        .shadow(radius: 5)
                                }
                                
                                Button {
                                    moveRight()
                                } label: {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 55))
                                        .foregroundColor(.Burgundy)
                                        .shadow(radius: 5)
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
                    ConfettiView().zIndex(20)
                }
            }
            .onAppear { generateNewPuzzle() }
        }
        .navigationViewStyle(.stack)
    }
    
    
    // MARK: - Logic
    
    private func generateNewPuzzle() {
        let possible = [1, 2, 3, 4, 5]
        columns = Array(possible.shuffled().prefix(3))
        selectedIndex = 0
    }
    
    
    private func moveLeft() {
        guard selectedIndex > 0 else { return }
        
        withAnimation(.easeInOut(duration: 0.25)) {
            columns.swapAt(selectedIndex, selectedIndex - 1)
            selectedIndex -= 1
        }
        
        checkCompletion()
    }
    
    
    private func moveRight() {
        guard selectedIndex < columns.count - 1 else { return }
        
        withAnimation(.easeInOut(duration: 0.25)) {
            columns.swapAt(selectedIndex, selectedIndex + 1)
            selectedIndex += 1
        }
        
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
        columns == columns.sorted()
    }
}



// MARK: - Preview
struct Level4Page_Previews: PreviewProvider {
    static var previews: some View {
        Level4Page()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
