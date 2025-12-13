//
//  Level7Page.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 22/06/1447 AH.
//
import SwiftUI
import UniformTypeIdentifiers

struct Level7Page: View {
    
    // MARK: - State
    
    @State private var currentCount: Int = 0
    @State private var targetCount: Int = 0
    @State private var addedCount: Int = 0
    @State private var sparklePhase: CGFloat = 0

    @State private var sparkleTick = false   // ✅ الحالة الصحيحة للأنميشن
    let sparklePositions: [CGPoint] = [
        CGPoint(x: -50, y: -50),
        CGPoint(x: 35, y: -30),
        CGPoint(x: -30, y: 35),
        CGPoint(x: 40, y: 40),
        CGPoint(x: -45, y: 20),
        CGPoint(x: 30, y: -55)
    ]

    @State private var completedQuestions = 0
    let totalQuestionsInLevel = 5
    
    @State private var showConfetti = false
    @State private var isCorrect = false
    
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
                        
                        VStack(spacing: 35) {
                            
                            // العنوان
                            Text("اسحب من الكنز حتى نكمل العدد")
                                .font(.custom("Farah", size: 50))
                                .foregroundColor(.CinnamonWood)
                                .shadow(radius: 10)
                                .padding(.top, 60)
                                .padding(.horizontal, 150)
                            
                            // ===== العدّ البصري =====
                            HStack(spacing: 16) {
                                ForEach(0..<targetCount, id: \.self) { index in
                                    Image("kanz")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 75, height: 75)
                                        .opacity(index < currentCount + addedCount ? 1 : 0.25)
                                }
                            }
                            
                            // ===== عدّاد الجمع =====
                            HStack(spacing: 12) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 34))
                                    .foregroundColor(.CinnamonWood)
                                
                                Text(" \(addedCount)")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.CinnamonWood)
                            }
                            
                            // ===== الكنز الكبير (السحب) =====
                            ZStack {
                                
                                // صورة الكنز (ثابتة)
                                Image("kanz")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                
                                // ✨ السباركلز (مستقرة)
                                ForEach(sparklePositions.indices, id: \.self) { i in
                                    Image(systemName: "sparkle")
                                        .font(.system(size: 22))
                                        .foregroundColor(.yellow.opacity(0.9))
                                        .offset(
                                            x: sparklePositions[i].x,
                                            y: sparklePositions[i].y
                                        )
                                        .opacity(sparkleTick ? 1 : 0)
                                        .animation(
                                            .easeInOut(duration: 1.8)
                                                .repeatForever(autoreverses: true)
                                                .delay(Double(i) * 0.2),
                                            value: sparkleTick
                                        )
                                }
                                .environment(\.layoutDirection, .leftToRight)


                            }
                            .environment(\.layoutDirection, .leftToRight)

                            .frame(width: 120, height: 120)
                            .clipped()
                            .onAppear {
                                sparkleTick.toggle()
                            }
                            .onDrag {
                                NSItemProvider(object: "kanz" as NSString)
                            }
                            
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
                        .onDrop(of: [.plainText], isTargeted: nil) { _ in
                            handleDrop()
                        }
                        
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
                    ConfettiView()
                        .zIndex(20)
                }
            }
            .onAppear {
                generateNewQuestion()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Logic
    
    private func generateNewQuestion() {
        let target = Int.random(in: 3...6)
        let current = Int.random(in: 1..<target)
        
        targetCount = target
        currentCount = current
        addedCount = 0
        isCorrect = false
    }
    
    
    private func handleDrop() -> Bool {
        
        guard currentCount + addedCount < targetCount else {
            return false
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            addedCount += 1
        }
        
        if currentCount + addedCount == targetCount {
            isCorrect = true
            completedQuestions += 1
            showConfetti = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showConfetti = false
                if completedQuestions < totalQuestionsInLevel {
                    generateNewQuestion()
                }
            }
        }
        
        return true
    }
}


// MARK: - Preview
struct Level7Page_Previews: PreviewProvider {
    static var previews: some View {
        Level7Page()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
