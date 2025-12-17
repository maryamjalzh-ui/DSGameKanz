//
//  DSGameKanzApp.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 29/05/1447 AH.
//

import SwiftUI

@main
struct DSGameKanzApp: App {
    @StateObject private var languageManager = LanguageManager()
    @StateObject private var progress = GameProgress()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(languageManager)
                .environmentObject(progress)
        }
    }
}
