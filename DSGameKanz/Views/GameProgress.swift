import Foundation
import Combine

final class GameProgress: ObservableObject {

    // MARK: - Stored Progress
    @Published private(set) var completedLevels: Int {
        didSet {
            UserDefaults.standard.set(completedLevels, forKey: "completedLevels")
        }
    }

    @Published var mainCharacter: String? {
        didSet {
            UserDefaults.standard.set(mainCharacter, forKey: "mainCharacter")
        }
    }

    @Published var unlockedCharacters: Set<String> {
        didSet {
            UserDefaults.standard.set(Array(unlockedCharacters), forKey: "unlockedCharacters")
        }
    }

    // MARK: - Constants
    private let allCharactersOrder: [String] = ["nina", "hopper", "jack", "yousef", "maya"]

    // MARK: - Init (تحميل التقدم)
    init() {
        self.completedLevels = UserDefaults.standard.integer(forKey: "completedLevels")
        self.mainCharacter = UserDefaults.standard.string(forKey: "mainCharacter")

        let savedCharacters = UserDefaults.standard.array(forKey: "unlockedCharacters") as? [String]
        self.unlockedCharacters = Set(savedCharacters ?? [])
    }

    // MARK: - Character Selection
    func selectMainCharacter(_ name: String) {
        mainCharacter = name
        unlockedCharacters = [name]
        completedLevels = 0
    }

    // MARK: - Level Progress Logic

    /// تُنادى من CompletedLevelView
    func completeLevelIfNeeded(_ level: Int) {

        // لو أعاد لعب ليفل قديم → تجاهل
        guard level > completedLevels else { return }

        completedLevels = level

        // كل ليفلين → شخصية جديدة
        if completedLevels % 2 == 0 {
            unlockNextCharacterIfNeeded()
        }
    }

    // MARK: - Unlock Characters
    private func unlockNextCharacterIfNeeded() {
        guard let main = mainCharacter else { return }

        if unlockedCharacters.count >= allCharactersOrder.count { return }

        if let next = allCharactersOrder.first(where: {
            $0 != main && !unlockedCharacters.contains($0)
        }) {
            unlockedCharacters.insert(next)
        }
    }

    // MARK: - Helpers (للرود ماب)
    func isLevelUnlocked(_ level: Int) -> Bool {
        level <= completedLevels + 1
    }
}
