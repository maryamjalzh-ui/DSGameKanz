//
//  DSGameKanzApp.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 29/05/1447 AH.
//
// 📄 DSGameKanzApp.swift (الكود الصحيح والوحيد)

import SwiftUI

enum AppRoute {
    case map
    case level
}

@main
struct DSGameKanzApp: App {
    @State private var route: AppRoute = .level

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                switch route {
                case .map:
                    RoadMapPage()
                case .level:
                    InLevelPage(onLevelCompleted: {
                        route = .map
                    })
                }
            }
        }
    }
}
