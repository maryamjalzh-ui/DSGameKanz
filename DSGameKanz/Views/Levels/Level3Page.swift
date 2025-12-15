//
//  Level4Page.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 20/06/1447 AH.
//
//
//  Level4Page.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 20/06/1447 AH.
//

import SwiftUI
import UniformTypeIdentifiers

struct Level3Page: View {
    
    // ✅ (1) ربط التقدم
    @EnvironmentObject var progress: GameProgress
    
    @State private var columns: [Int] = []
    @State private var selectedIndex: Int = 0
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    @State private var bounce: Bool = false
    
    @State private var completedQuestions = 0
    let totalQuestionsInLevel = 5
    
    @State private var showConfetti = false
    
    // ✅ (2) الانتقالات
    @State private var goToCompletedLevel = false
    @State private var goToMap = false   // 👈 الجديد
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // 🔹 صفحة الإكمال
                NavigationLink(
                    destination: LevelCompletedView(
                        levelNumber: 3,
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
                    
                    ZStack(alignment: .bottomTrailing) {
                        
                        VStack(spacing: 50) {
                            HStack(spacing: 16) {
                                
                                // 🔊 زر السماعة
                                Button {
                                    BackgroundMusicManager.shared.playVoiceOver("level3voiceover")
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.CinnamonWood)
                                        .padding(.top, 50)
                                        .padding(.trailing, -40)
                                }
                                .accessibilityLabel("تشغيل صوت السؤال")
                                
                                Text("رتب الكنوز من الأصغر إلى الأكبر")
                                    .font(.custom("Farah", size: 50))
                                    .foregroundColor(.CinnamonWood)
                                    .shadow(radius: 10)
                                    .padding(.top, 50)
                                    .padding(.horizontal, 50)
                            }
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
                                LinearGradient(
                                    colors: [
                                        Color.Fern.opacity(0.18),
                                        Color.clear
                                    ],
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
                        .frame(maxWidth: 700)
                        .padding(.horizontal, 50)
                        
                        Image(isSortedCorrectly() ? "happy" : "thinking")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .offset(x: -90, y: 50)
                    }
                    
                    Spacer()
                }
                
                if showConfetti {
                    ConfettiView().zIndex(20)
                }
            }
            .onAppear {
                startBounce()
                generateNewPuzzle()
            }
            .onAppear {
                BackgroundMusicManager.shared.playVoiceOver("level3voiceover")
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
        
        repeat {
            let picked = Array(possible.shuffled().prefix(3))
            let correct = picked.sorted(by: <)
            current = correct
            
            let i = Int.random(in: 0..<current.count)
            var j = Int.random(in: 0..<current.count)
            while j == i {
                j = Int.random(in: 0..<current.count)
            }
            
            current.swapAt(i, j)
            columns = current
            
        } while isSortedCorrectly()
        
        selectedIndex = Int.random(in: 0..<columns.count)
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
                } else {
                    // ✅ نهاية الليفل
                    goToCompletedLevel = true
                }
            }
        }
    }
    
    private func isSortedCorrectly() -> Bool {
        Array(columns.reversed()) == columns.sorted(by: <)
    }
}

struct Level3Page_Previews: PreviewProvider {
    static var previews: some View {
        Level3Page()
            .environmentObject(GameProgress())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
