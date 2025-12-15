//
//  Level7Page.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 22/06/1447 AH.
//
import SwiftUI
import UniformTypeIdentifiers

struct Level7Page: View {
    
    // ✅ (1) ربط التقدم
    @EnvironmentObject var progress: GameProgress
    
    // MARK: - State
    @State private var currentCount: Int = 0
    @State private var targetCount: Int = 0
    @State private var addedCount: Int = 0

    @State private var sparkleTick = false
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
    
    // ✅ (2) الانتقالات
    @State private var goToCompletedLevel = false
    @State private var goToMap = false   // 👈 الجديد
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                // 🔹 صفحة الإكمال
                NavigationLink(
                    destination: LevelCompletedView(
                        levelNumber: 7,
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
                            HStack(spacing: 16) {
                                
                                Button {
                                    BackgroundMusicManager.shared.playVoiceOver("level7voiceover")
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.CinnamonWood)
                                        .shadow(radius: 10)
                                }
                                .accessibilityLabel("تشغيل صوت السؤال")
                                
                                Text("اسحب من الكنز حتى نكمل العدد")
                                    .font(.custom("Farah", size: 50))
                                    .foregroundColor(.CinnamonWood)
                                    .shadow(radius: 10)
                            }
                            .padding(.top, 50)
                            .padding(.horizontal, 50)
                            
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
                                
                                Text("\(addedCount)")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.CinnamonWood)
                            }
                            
                            // ===== الكنز الكبير (السحب) =====
                            ZStack {
                                Image("kanz")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                
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
                            }
                            .environment(\.layoutDirection, .leftToRight)
                            .frame(width: 120, height: 120)
                            .onAppear { sparkleTick.toggle() }
                            .onAppear {
                                BackgroundMusicManager.shared.playVoiceOver("level7voiceover")
                            }
                            .onDrag {
                                NSItemProvider(object: "kanz" as NSString)
                            }
                            
                        }
                        .background(
                            ZStack {
                                LinearGradient(
                                    colors: [Color.Fern.opacity(0.18), Color.clear],
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
                        .padding(.horizontal, 50)
                        .onDrop(of: [.plainText], isTargeted: nil) { _ in
                            handleDrop()
                        }
                        
                        Image(isCorrect ? "happy" : "thinking")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .offset(x: -90, y: 50)
                    }
                    
                    Spacer()
                }
                
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
                } else {
                    // ✅ نهاية الليفل
                    goToCompletedLevel = true
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
            .environmentObject(GameProgress())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
