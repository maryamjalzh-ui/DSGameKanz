import Foundation
import SwiftUI
import Combine

@MainActor
class LanguageManager: ObservableObject {
    @Published var isArabic: Bool {
        didSet {
            UserDefaults.standard.set(isArabic, forKey: "is_arabic_language")
        }
    }
    
    init() {
        // Default = Arabic
        if UserDefaults.standard.object(forKey: "is_arabic_language") == nil {
            self.isArabic = true
        } else {
            self.isArabic = UserDefaults.standard.bool(forKey: "is_arabic_language")
        }
    }
    
    func toggleLanguage() {
        isArabic.toggle()
    }
}
