//
//  GameProgress.swift
//  DSGameKanz
//
//  Created by Abeer Alshabrami on 12/9/25.
//
import Foundation
import Combine

final class GameProgress: ObservableObject {
    
    @Published var mainCharacter: String? = nil
    @Published var unlockedCharacters: Set<String> = []
    @Published var completedLevels: Int = 0
    
    /// ترتيب فتح الشخصيات
    private let allCharactersOrder: [String] = ["nina", "hopper", "jack", "yousef", "maya"]
    
    // اختيار الشخصية الأساسية
    func selectMainCharacter(_ name: String) {
        mainCharacter = name
        unlockedCharacters = [name]
        completedLevels = 0
    }
    
    // تسجيل تقدم اللاعب عند إنهاء ليفل
    func registerLevelCompleted() {
        completedLevels += 1
        
        // كل مرحلتين ينفتح صديق جديد
        if completedLevels % 2 == 0 {
            unlockNextCharacterIfNeeded()
        }
    }
    
    private func unlockNextCharacterIfNeeded() {
        guard let main = mainCharacter else { return }
        
        // لو كل الشخصيات مفتوحة، نوقف
        if unlockedCharacters.count >= allCharactersOrder.count { return }
        
        if let next = allCharactersOrder.first(where: { $0 != main && !unlockedCharacters.contains($0) }) {
            unlockedCharacters.insert(next)
        }
    }
}
