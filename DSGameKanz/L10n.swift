import SwiftUI

enum LKey {
    case startJourney
    case chooseCharacter
    case ready
    case youArrived
    // add more keys as you need
}

extension LanguageManager {
    func text(_ key: LKey) -> String {
        switch (isArabic, key) {
        case (true, .startJourney):     return "ابدأ رحلتك"
        case (false, .startJourney):    return "Start your journey"

        case (true, .chooseCharacter):  return "اختر شخصيتك!"
        case (false, .chooseCharacter): return "Choose your character!"

        case (true, .ready):            return "هل أنت مستعد؟"
        case (false, .ready):           return "Are you ready?"

        case (true, .youArrived):       return "لقد وصلت!"
        case (false, .youArrived):      return "You arrived!"
        }
    }
}

