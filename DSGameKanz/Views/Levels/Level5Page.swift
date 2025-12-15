//  Level5Page.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 20/06/1447 AH.
//

import SwiftUI
import UniformTypeIdentifiers

struct Level5Page: View {
    
    @EnvironmentObject var progress: GameProgress
    
    let treasureSymbols = ["🌴", "💎", "🪵", "🪙", "🗺️", "🏝️"]
    
    @State private var columns: [Int] = []
    @State private var columnSymbols: [Int: String] = [:]
    @State private var dropTargets: [Int] = []
    @State private var solvedColumns: Set<Int> = []
    @State private var correctTargets: Set<Int> = []
    
    @State private var wrongTarget: Int? = nil   // 👈 جديد
    
    @State private var completedQuestions = 0
    let totalQuestionsInLevel = 5
    
    @State private var showConfetti = false
    @State private var isFullySolved = false
    
    @State private var goToCompletedLevel = false
    @State private var goToMap = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                NavigationLink(
                    destination: LevelCompletedView(
                        levelNumber: 5,
                        goToMap: $goToMap
                    )
                    .environmentObject(progress),
                    isActive: $goToCompletedLevel
                ) { EmptyView() }
                
                NavigationLink(
                    destination: RoadMap()
                        .environmentObject(progress),
                    isActive: $goToMap
                ) { EmptyView() }
                
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
                        
                        VStack(spacing: 10) {
                            
                            HStack(spacing: 16) {
                                Button {
                                    BackgroundMusicManager.shared.playVoiceOver("level5voiveover")
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.CinnamonWood)
                                        .offset(y: 4)
                                        .shadow(radius: 10)
                                }
                                .accessibilityLabel("تشغيل صوت السؤال")
                                
                                Text("اسحب الاشكال إلى عددها الصحيح")
                                    .font(.custom("Farah", size: 50))
                                    .foregroundColor(.CinnamonWood)
                                    .shadow(radius: 10)
                            }
                            .padding(.top, 50)
                            .padding(.horizontal, 30)
                            
                            // الأعمدة
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
                                        .id(value)
                                        .draggable("\(value)")
                                    }
                                }
                            }
                            
                            // الأهداف
                            HStack(spacing: 40) {
                                ForEach(dropTargets, id: \.self) { option in
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(
                                                correctTargets.contains(option)
                                                ? Color.Fern
                                                : (wrongTarget == option
                                                   ? Color.CinnamonWood
                                                   : Color.Burgundy)
                                            )
                                            .frame(width: 100, height: 60)
                                            .shadow(radius: 6)
                                        
                                        Text("\(option)")
                                            .font(.system(size: 34, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .onDrop(of: [.text], isTargeted: nil) { providers in
                                        handleDrop(providers: providers, target: option)
                                    }
                                }
                            }
                            .padding(.bottom, 40)
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
                        
                        Image(isFullySolved ? "happy" : "thinking")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .shadow(radius: 5)
                            .offset(x: -90, y: 50)
                    }
                    
                    Spacer()
                }
                
                if showConfetti {
                    ConfettiView().zIndex(20)
                }
            }
            .onAppear {
                generateNewPuzzle()
                BackgroundMusicManager.shared.playVoiceOver("level5voiveover")
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Logic
    
    private func generateNewPuzzle() {
        let possible = [2, 3, 4, 5, 6]
        
        columns = Array(possible.shuffled().prefix(3)).sorted()
        solvedColumns.removeAll()
        correctTargets.removeAll()
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
            guard
                let ns = object as? NSString,
                let draggedValue = Int(ns as String)
            else { return }
            
            DispatchQueue.main.async {
                if draggedValue == target {
                    
                    solvedColumns.insert(target)
                    correctTargets.insert(target)
                    
                    if solvedColumns.count == columns.count {
                        isFullySolved = true
                        completedQuestions += 1
                        showConfetti = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showConfetti = false
                            completedQuestions < totalQuestionsInLevel
                            ? generateNewPuzzle()
                            : (goToCompletedLevel = true)
                        }
                    }
                } else {
                    wrongTarget = target
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        wrongTarget = nil
                    }
                }
            }
        }
        return true
    }
}

// MARK: - Preview
struct Level5Page_Previews: PreviewProvider {
    static var previews: some View {
        Level5Page()
            .environmentObject(GameProgress())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
