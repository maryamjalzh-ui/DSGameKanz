//
//  DSGameKanzApp.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 29/05/1447 AH.
//

import SwiftUI

@main
struct YourGameApp: App {
    
    @StateObject private var progress = GameProgress()
    
    var body: some Scene {
        WindowGroup {
            StartingPage()
                .environmentObject(progress)
        }
    }
}
