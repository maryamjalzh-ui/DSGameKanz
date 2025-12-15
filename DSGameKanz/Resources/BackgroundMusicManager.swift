//
//  BackgroundMusicManager.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 24/06/1447 AH.
//

import Foundation
import AVFoundation

final class BackgroundMusicManager {
    
    static let shared = BackgroundMusicManager()
    
    // 🎵 موسيقى الخلفية
    private var musicPlayer: AVAudioPlayer?
    
    // 🗣️ فويس أوفر
    private var voicePlayer: AVAudioPlayer?

    private init() {}

    // MARK: - Background Music
    
    func startMusic() {
        guard let url = Bundle.main.url(
            forResource: "backgroundMusic",
            withExtension: "mp3"
        ) else {
            print("❌ background music file not found")
            return
        }

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.volume = 0.4
            musicPlayer?.play()
        } catch {
            print("❌ Failed to play background music:", error)
        }
    }

    func stopMusic() {
        musicPlayer?.stop()
    }

    // MARK: - Voice Over
    
    /// تشغيل فويس أوفر (مرة واحدة)
    func playVoiceOver(_ fileName: String) {
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "mp3"
        ) else {
            print("❌ Voice file not found:", fileName)
            return
        }

        do {
            // نوقف أي فويس سابق
            voicePlayer?.stop()
            
            // نخفض صوت الموسيقى شوي
            musicPlayer?.volume = 0.15
            
            voicePlayer = try AVAudioPlayer(contentsOf: url)
            voicePlayer?.volume = 1.0
            voicePlayer?.play()
        } catch {
            print("❌ Failed to play voice over:", error)
        }
    }

    func stopVoiceOver() {
        voicePlayer?.stop()
        musicPlayer?.volume = 0.4
    }
}
