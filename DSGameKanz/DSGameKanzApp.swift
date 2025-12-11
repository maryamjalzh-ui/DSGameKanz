//
//  DSGameKanzApp.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 29/05/1447 AH.
//

import SwiftUI

@main
struct DSGameKanzApp: App {
    @StateObject var progress = GameProgress() // إنشاء الكائن هنا مرة واحدة

    var body: some Scene {
        WindowGroup {
            Level3Page()
                .environmentObject(progress) // تمرير الكائن
        }
    }
}
struct YourAppNameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()   // ← MUST be ContentView, not StartingPage, not CharacterChoice
        }
    }
}

