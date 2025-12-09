import SwiftUI

enum CharacterType: String {
    case female
    case male
}

struct CharacterChoice: View {
    
    @EnvironmentObject var progress: GameProgress
    
    // saved permanently in UserDefaults
    @AppStorage("selectedCharacter") private var selectedCharacterRaw: String = ""
    
    @State private var float = false
    @State private var goToRoadmap = false   // controls NavigationLink
    
    // MARK: - Helpers
    private var isFemaleSelected: Bool {
        selectedCharacterRaw == CharacterType.female.rawValue
    }
    private var isMaleSelected: Bool {
        selectedCharacterRaw == CharacterType.male.rawValue
    }
    private var selectedCharacter: CharacterType? {
        CharacterType(rawValue: selectedCharacterRaw)
    }
    
    // MARK: - Colors
    private var defaultColor: Color { .Burgundy }   // red
    private var selectedColor: Color { .Fern }      // green
    
    var body: some View {
        NavigationStack {   // main navigation container
            ZStack {
                
                // background
                Color.primary.ignoresSafeArea()
                
                Image("Choose")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // title
                VStack(alignment: .center, spacing: 8) {
                    Text("اختر شخصيتك!")
                }
                .font(.custom("Farah", size: 60))
                .padding(.top, -250)
                .foregroundColor(.CinnamonWood)
                
                VStack {
                    Spacer().frame(height: 80)
                    
                    if selectedCharacter == nil {
                        // ------------------------------------------------
                        //   STATE 1: BOTH CHARACTERS VISIBLE (CHOOSING)
                        // ------------------------------------------------
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
                                    selectedCharacterRaw = CharacterType.female.rawValue
                                    
                                    // link to profile character (change name if needed)
                                    progress.selectMainCharacter("nina")
                                    
                                } label: {
                                    Text("1")
                                        .font(.custom("Farah", size: 36))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 40)
                                        .padding(.vertical, 8)
                                        .background(
                                            isFemaleSelected ? selectedColor : defaultColor
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
                                    
                                    // link to profile character (change name if needed)
                                    progress.selectMainCharacter("yousef")
                                    
                                } label: {
                                    Text("2")
                                        .font(.custom("Farah", size: 36))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 40)
                                        .padding(.vertical, 8)
                                        .background(
                                            isMaleSelected ? selectedColor : defaultColor
                                        )
                                        .cornerRadius(20)
                                }
                            }
                        }
                        
                    } else {
                        // ------------------------------------------------
                        //   STATE 2: ONE CHARACTER + "ابدأ" BUTTON
                        // ------------------------------------------------
                        VStack(spacing: 32) {
                            
                            // show selected character only
                            Image(selectedCharacter == .female ? "Female" : "Male")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 180)
                                .offset(y: float ? -8 : 8)
                                .animation(
                                    .easeInOut(duration: 1.0)
                                        .repeatForever(autoreverses: true),
                                    value: float
                                )
                            
                            // NavigationLink styled as your "ابدأ" button
                            NavigationLink(
                                destination: RoadMap()
                                    .environmentObject(progress),  // pass progress to next screen if needed
                                isActive: $goToRoadmap
                            ) {
                                Button {
                                    goToRoadmap = true
                                } label: {
                                    Text("ابدأ")
                                        .font(.custom("Farah", size: 40))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 60)
                                        .padding(.vertical, 10)
                                        .background(Color.Fern)
                                        .cornerRadius(25)
                                }
                            }
                            .buttonStyle(.plain)  // so it keeps your custom button style
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    Spacer().frame(height: 9)
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                float = true
                selectedCharacterRaw = ""   // reset when entering screen
            }
        }
    }
}

// MARK: - PREVIEW

struct CharacterChoice_Previews: PreviewProvider {
    static var previews: some View {
        CharacterChoice()
            .environmentObject(GameProgress())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
