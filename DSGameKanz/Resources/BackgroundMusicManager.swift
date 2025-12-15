//
//  BackgroundMusicManager.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani
//

import Foundation
import AVFoundation
import SwiftUI

final class BackgroundMusicManager {
    
    static let shared = BackgroundMusicManager()
    
    // 🎵 مشغل الموسيقى
    private var musicPlayer: AVAudioPlayer?
    
    // 🗣️ مشغل الفويس أوفر
    private var voicePlayer: AVAudioPlayer?
    
    // 🔑 حفظ حالة الموسيقى
    @AppStorage("isMusicEnabled") private var isMusicEnabled: Bool = true
    
    private init() {}

    // MARK: - Background Music
    
    /// تشغيل الموسيقى بعد تأخير (مثلاً بعد السبلاش)
    func startMusic(after delay: TimeInterval = 3.0) {
        guard isMusicEnabled else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard self.isMusicEnabled else { return }
            self.playBackgroundMusic()
        }
    }
    
    /// التشغيل الفعلي
    private func playBackgroundMusic() {
        if musicPlayer?.isPlaying == true { return }
        
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

    /// إيقاف الموسيقى
    func stopMusic() {
        musicPlayer?.pause()
    }
    
    // MARK: - Public Control (للإعدادات)
    
    /// تغيير حالة الموسيقى (زر ON / OFF)
    func setMusicEnabled(_ enabled: Bool) {
        isMusicEnabled = enabled
        
        if enabled {
            playBackgroundMusic()
        } else {
            stopMusic()
        }
    }
    
    /// قراءة الحالة (للزر)
    func isMusicOn() -> Bool {
        isMusicEnabled
    }

    // MARK: - Voice Over
    
    /// تشغيل فويس أوفر مرة واحدة
    func playVoiceOver(_ fileName: String) {
        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "mp3"
        ) else {
            print("❌ Voice file not found:", fileName)
            return
        }

        do {
            voicePlayer?.stop()
            
            // خفض صوت الموسيقى مؤقتًا
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
