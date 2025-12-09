import SwiftUI

enum CharacterType: String {
    case female
    case male
}

struct CharacterChoice: View {
    
    @AppStorage("selectedCharacter") private var selectedCharacterRaw: String = ""
    
    @State private var float = false
    @State private var goToRoadmap = false   // ← navigation trigger
    
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
        NavigationStack {   // wrap whole screen in NavigationStack
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
                                } label: {
                                    Text("1")
                                        .font(.custom("Farah", size: 36))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 40)
                                        .padding(.vertical, 8)
                                        .background(isFemaleSelected ? selectedColor : defaultColor)
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
                                        .background(isMaleSelected ? selectedColor : defaultColor)
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
                            
                            // "ابدأ" button → RoadMap
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
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    Spacer().frame(height: 9)
                }
            }
            // where the button navigates to
            .navigationDestination(isPresented: $goToRoadmap) {
                RoadMap()
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                float = true
                selectedCharacterRaw = ""   // reset on enteringkk screen
            }
        }
    }
}

// MARK: - PREVIEW

struct CharacterChoice_Previews: PreviewProvider {
    static var previews: some View {
        CharacterChoice()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

