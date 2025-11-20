//
//  Colors.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 29/05/1447 AH.
//
import Foundation
import SwiftUI
import UIKit   // عشان نستخدم .systemBackground و .secondarySystemBackground

// MARK: - Color from Hex helper
extension Color {
    // Initialize a Color instance using a hex string (e.g., "#FFFFFF" or "FFFFFF")
    init(hex: String) {
        // Remove any non-alphanumeric characters (like #)
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        // Convert hex string to an integer value
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        // Determine the format based on the length of the hex string
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: // Invalid format, fallback to white
            (a, r, g, b) = (1, 1, 1, 0)
        }
        // Create the color using RGB components normalized to 0–1
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}


// MARK: - App Colors (Dynamic)
extension Color {
    // Background that automatically adapts to light/dark mode
    static var primaryBackground: Color {
        Color(.systemBackground)
    }
    
    // Secondary background (e.g., for cards or grouped elements)
    static var darkGreyBackground: Color {
        Color(.secondarySystemBackground)
    }
    // ملاحظه اسماء متغييرات الالوان هي نفسها الاسماء اللي بصفحه سكيتش
    
    // اللون السماوي حق البرنامج
    static let PacificBlue = Color(hex: "#63B0CD")

    // اللون الاخضر حق اللعبه
    static let Fern = Color(hex: "#4A7856")

    // اللون الاحمر
    static let Burgundy  = Color(hex: "#7D1128")
    // اللون الخشبي
    static let CinnamonWood = Color(hex: "#A9714B")

    // Dynamic text colors that adapt to light/dark mode
    static var primaryText: Color { Color.primary }
    static var secondaryText: Color { Color.secondary }

}
