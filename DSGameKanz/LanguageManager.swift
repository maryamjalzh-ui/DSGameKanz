import Foundation
import Combine

final class LanguageManager: ObservableObject {
    @Published var isArabic: Bool {
        didSet { UserDefaults.standard.set(isArabic, forKey: "isArabic") }
    }

    init() {
        // Default Arabic
        if UserDefaults.standard.object(forKey: "isArabic") == nil {
            isArabic = true
        } else {
            isArabic = UserDefaults.standard.bool(forKey: "isArabic")
        }
    }

    func toggle() { isArabic.toggle() }
}
