import SwiftUI

struct ProfilePage: View {
    
    @EnvironmentObject var progress: GameProgress
    
    @State private var selected: String? = nil
    
    let characters = ["nina", "hopper", "jack", "yousef", "maya"]
    
    private let characterSizes: [String: CGSize] = [
        "nina":   CGSize(width: 130, height: 110),
        "hopper": CGSize(width: 140, height: 129),
        "jack":   CGSize(width: 100, height: 115),
        "yousef": CGSize(width: 100, height: 115),
        "maya":   CGSize(width: 130, height: 140)
    ]
    
    private let characterOffsets: [String: CGSize] = [
        "nina":   CGSize(width: 0,  height: 10),
        "hopper": CGSize(width: -5,  height: 3),
        "jack":   CGSize(width: 0,  height: 8),
        "yousef": CGSize(width: 0,  height: 8),
        "maya":   CGSize(width: 0,  height: 0)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color(red: 254/255, green: 244/255, blue: 217/255)
                    .ignoresSafeArea()
                
                Image("main1")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .clipped()
                
                // ⚙️ زر إعدادات الصوت (مرتبط مباشرة بالمانجر)
                VStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            toggleBackgroundMusic()
                        } label: {
                            Image(systemName:
                                BackgroundMusicManager.shared.isMusicOn()
                                ? "speaker.wave.2.fill"
                                : "speaker.slash.fill"
                            )
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.Burgundy)
                            .padding(14)
                            .background(Color.white.opacity(0.85))
                            .clipShape(Circle())
                            .shadow(radius: 6)
                        }
                        .padding(.trailing, 30)
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                }
                
                VStack(spacing: 100) {
                    
                    Spacer().frame(height: 230)
                    
                    // الصف الأول
                    HStack(spacing: 55) {
                        profileCharacter(name: characters[0])
                        profileCharacter(name: characters[2])
                        profileCharacter(name: characters[1])
                    }
                    
                    // الصف الثاني
                    HStack(spacing: 80) {
                        profileCharacter(name: characters[3])
                        profileCharacter(name: characters[4])
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func toggleBackgroundMusic() {
        let current = BackgroundMusicManager.shared.isMusicOn()
        BackgroundMusicManager.shared.setMusicEnabled(!current)
    }
    
    // MARK: - Character UI
    
    @ViewBuilder
    private func profileCharacter(name: String) -> some View {
        let isUnlocked = progress.unlockedCharacters.contains(name)
        let box = characterBox(name: name, isUnlocked: isUnlocked)
        
        if isUnlocked {
            Button {
                selected = name
            } label: {
                box
            }
            .buttonStyle(.plain)
        } else {
            box
        }
    }
    
    private func characterBox(name: String, isUnlocked: Bool) -> some View {
        
        let boxSize: CGFloat = 140
        
        let size   = characterSizes[name]  ?? CGSize(width: 90, height: 90)
        let offset = characterOffsets[name] ?? CGSize(width: 0,  height: 0)
        
        return ZStack {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
            
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: size.width, height: size.height)
                .offset(x: offset.width, y: offset.height)
                .blur(radius: isUnlocked ? 0 : 4)
                .opacity(isUnlocked ? 1.0 : 0.6)
            
            if !isUnlocked {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.35))
                
                Image(systemName: "lock.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    Color(
                        hex: isUnlocked
                        ? (selected == name ? "#A30000" : "#7B0909")
                        : "#7B0909"
                    )
                    .opacity(isUnlocked ? 1 : 0.4),
                    lineWidth: (selected == name && isUnlocked) ? 12 : 10
                )
        )
        .frame(width: boxSize, height: boxSize)
        .contentShape(Rectangle())
    }
}

#Preview(traits: .landscapeLeft)  {
    let progress = GameProgress()
    progress.selectMainCharacter("nina")
    progress.unlockedCharacters.insert("hopper")
    progress.unlockedCharacters.insert("jack")
    
    return NavigationStack {
        ProfilePage()
            .environmentObject(progress)
    }
}
