import SwiftUI

enum CharacterType: String {
    case female
    case male
}

struct CharacterChoice: View {
    // stored in UserDefaults
    @AppStorage("selectedCharacter") private var selectedCharacterRaw: String = ""
    
    @State private var float = false      // for up–down animation
    
    // helpers
    private var isFemaleSelected: Bool {
        selectedCharacterRaw == CharacterType.female.rawValue
    }
    private var isMaleSelected: Bool {
        selectedCharacterRaw == CharacterType.male.rawValue
    }
    
    var body: some View {
        ZStack {
            // background
            Color.primary.ignoresSafeArea()
            
            Image("Choose")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // content
            VStack {
                Spacer().frame(height: 80)
                
                HStack(alignment: .center, spacing: 160) {
                    
                    // FEMALE
                    VStack(spacing: 24) {
                        Image("Female")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180)
                            .offset(y: float ? -8 : 8)
                            .animation(
                                .easeInOut(duration: 1.0)
                                    .repeatForever(autoreverses: true),
                                value: float
                            )
                        
                        Button {
                            // ✅ just save the raw value
                            selectedCharacterRaw = CharacterType.female.rawValue
                        } label: {
                            Text("1")
                                .font(.custom("Farah", size: 36))
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 8)
                                .background(
                                    isFemaleSelected
                                    ? Color.Fern       // selected = green
                                    : Color.Burgundy        // default
                                )
                                .cornerRadius(20)
                        }
                    }
                    
                    // MALE
                    VStack(spacing: 73) {
                        Image("Male")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180)
                            .offset(y: float ? 8 : -8)
                            .animation(
                                .easeInOut(duration: 1.0)
                                    .repeatForever(autoreverses: true),
                                value: float
                            )
                        
                        Button {
                            selectedCharacterRaw = CharacterType.male.rawValue
                            
                        } label: {
                            Text("2")
                                .font(.custom("Farah", size: 36))
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 8)
                                .background(
                                    isMaleSelected
                                    ? Color.Fern
                                    : Color.Burgundy
                                )
                                .cornerRadius(20)
                            
                        }
                    }
                }
                
                Spacer().frame(height: 9)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            float = true
        }
    }
}

struct CharacterChoice_Previews: PreviewProvider {
    static var previews: some View {
        CharacterChoice()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
