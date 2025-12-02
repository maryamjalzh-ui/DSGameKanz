//
//  InLevelPage.swift
//  DSGameKanz
//
//  Created by Maryam Jalal Alzahrani on 10/06/1447 AH.
//

import SwiftUI

// MARK: - 1. هياكل البيانات ومولّد الأنماط
// ----------------------------------------------------------------
struct DotPattern {
    let number: Int      // الرقم الصحيح (كم نقطة المفروض)
    let columns: [Int]   // كم نقطة في كل عمود
}

struct DotPatternGenerator {
    static let templates: [Int: [[Int]]] = [
        3: [[3], [2, 1]],
        4: [[4], [2, 2]],
        5: [[5], [3, 2]],
        6: [[5, 1], [3, 3]],
        7: [[5, 2], [4, 3], [3, 2, 2]],
        8: [[5, 3], [4, 4], [3, 3, 2]],
        9: [[5, 4], [3, 3, 3]]
    ]
    
    static var supportedNumbers: [Int] {
        Array(templates.keys).sorted()
    }
    
    static func randomPattern(for number: Int) -> DotPattern {
        let options = templates[number] ?? [[number]]
        let columns = options.randomElement() ?? [number]
        return DotPattern(number: number, columns: columns)
    }
    
    static func generateQuestion() -> (pattern: DotPattern, options: [Int]) {
        let newPattern = randomPatternInSupportedRange()
        
        // نولّد 3 اختيارات: واحد صحيح و 2 عشوائية (من الأرقام المدعومة)
        var optionsSet = Set<Int>()
        optionsSet.insert(newPattern.number)
        
        let numbers = supportedNumbers
        while optionsSet.count < 3 {
            if let random = numbers.randomElement() {
                optionsSet.insert(random)
            }
        }
        
        let options = Array(optionsSet).shuffled()
        return (pattern: newPattern, options: options)
    }
    
    static func randomPatternInSupportedRange() -> DotPattern {
        let nums = supportedNumbers
        let randomNumber = nums.randomElement() ?? 5
        return randomPattern(for: randomNumber)
    }
}

// MARK: - 2. عرض النقاط كنمط
// ----------------------------------------------------------------
struct DotPatternView: View {
    let pattern: DotPattern
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 24) {
            ForEach(pattern.columns.indices, id: \.self) { colIndex in
                let dotsCount = pattern.columns[colIndex]
                
                VStack(spacing: 8) {
                    ForEach(0..<dotsCount, id: \.self) { _ in
                        Circle()
                            .fill(Color.red) // لون النقاط
                            .frame(width: 28, height: 28)
                            .shadow(radius: 1)
                    }
                }
            }
        }
        .padding()
        // لجعل منطقة النقاط تأخذ مساحة كافية لتظهر فوق الورقة البنية
        .frame(minHeight: 150)
    }
}

// MARK: - 3. صفحة اللعبة الرئيسية (InLevelPage)
// ----------------------------------------------------------------
struct InLevelPage: View {
    
    // حالة السؤال والخيارات العشوائية
    @State private var currentPattern: DotPattern = DotPatternGenerator.randomPattern(for: 5)
    @State private var options: [Int] = []
    
    // حالة للتحقق من الإجابة وعرض التنبيه
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isAnswerCorrect = false
    @State private var questionCounter = 1 // لعد الأسئلة
    
    var body: some View {
        ZStack {
            
            // 1. الخلفية: صورة الخريطة الأساسية
            Image("BluredMap")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            // 2. المحتوى الأمامي: الورقة البنية مع السؤال والاختيارات
            VStack {
                Image("HandsOnMap")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 1000)
                    .overlay(
                        VStack(spacing: 3) {
                            
                            // العنوان ورقم المرحلة
                            Text("المرحلة الأولى")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.top, 40)
                            
                            // منطقة السؤال (السؤال ١)
                            Text("السؤال \(questionCounter)")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 300, height: 70)
                                .background(Color(red: 0.55, green: 0.1, blue: 0.15))
                                .cornerRadius(15)
                            
                            // عرض نمط النقاط هنا
                            Text("كم عدد النقاط؟")
                                .font(.title3)
                                .foregroundColor(.black)
                            
                            DotPatternView(pattern: currentPattern)
                                .padding(.vertical, 5)
                            
                            // منطقة الاختيارات (3 أزرار)
                            HStack(spacing: 15) {
                                // استخدام ForEach لعرض الأرقام كخيارات
                                ForEach(options, id: \.self) { option in
                                    NumberChoiceButton(number: option, action: {
                                        handleAnswer(option)
                                    }, isCorrect: option == currentPattern.number) // نحدد اللون الأخضر للإجابة الصحيحة
                                }
                            }
                            .padding(.horizontal, 40)
                            .padding(.bottom, 60) // مسافة لإبعاد الأزرار عن أسفل الورقة
                            
                            Spacer()
                        }
                        .padding(.top, 100)
                    )
                
                Spacer()
            }
        }
        .onAppear {
            generateNewQuestion() // توليد أول سؤال عند بدء الصفحة
        }
        // إضافة التنبيه (Alert) لإظهار النتيجة
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text(isAnswerCorrect ? "إجابة صحيحة! 🎉" : "إجابة خاطئة! 😔"),
                message: Text(alertMessage),
                dismissButton: .default(Text("التالي")) {
                    generateNewQuestion() // توليد سؤال جديد بعد الإغلاق
                }
            )
        }
    }
    
    // MARK: - منطق اللعبة
    
    /// توليد سؤال جديد (باترِن + خيارات)
    private func generateNewQuestion() {
        let (newPattern, newOptions) = DotPatternGenerator.generateQuestion()
        currentPattern = newPattern
        options = newOptions
        questionCounter += 1
        
        // إذا لم يكن السؤال الأول، نزيل التنبيه (في حال تم استدعاء الدالة بعد التنبيه)
        if questionCounter > 1 {
            showingAlert = false
        }
    }
    
    /// التحقق من الإجابة
    private func handleAnswer(_ answer: Int) {
        if answer == currentPattern.number {
            isAnswerCorrect = true
            alertMessage = "أحسنت! الإجابة صحيحة."
        } else {
            isAnswerCorrect = false
            alertMessage = "للأسف، الإجابة خاطئة. الإجابة الصحيحة هي: \(currentPattern.number)."
        }
        showingAlert = true
    }
}

// مكون فرعي لتمثيل زر اختيار الرقم
struct NumberChoiceButton: View {
    let number: Int
    let action: () -> Void
    let isCorrect: Bool
    
    // تحديد لون الخلفية بناءً على ما إذا كانت الإجابة صحيحة (فقط للعرض في الكود، اللون سيستخدم فقط عند الإجابة)
    // ولكن لتوحيد شكل الأزرار، سنستخدم اللون الأحمر الداكن والأخضر للزر الصحيح.
    var buttonColor: Color {
        // نختار لون مقارب لـ ... والأخضر للزر الأيمن كما في الصورة الأصلية.
        // بما أن الاختيارات عشوائية، سنستخدم اللون الأحمر الداكن للكل، ونجعل اللون الأخضر يظهر عند الضغط في منطق الـ Alert
        // لكن لتبدو الواجهة مشابهة لتصميمك الأصلي: سنجعل زر الإجابة الصحيحة يظهر باللون الأخضر هنا
        // بما أن الأزرار عشوائية، لا يمكننا تطبيق اللون الأخضر على زر ثابت، لذا سنعتمد على منطق الألوان الذي وضعته سابقا (أحمر للاثنين الأولين، أخضر للثالث)
        // لنستخدم الألوان المقاربة لصورتك الأصلية:
        return Color(red: 0.55, green: 0.1, blue: 0.15) // اللون الأحمر الداكن
    }
    
    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 100, height: 50)
                .background(isCorrect ? Color(red: 0.2, green: 0.5, blue: 0.25) : buttonColor) // نحدد لون الزر الصحيح ليميزه
                .cornerRadius(15)
        }
    }
}

// عرض المعاينة
struct InLevelPage_Previews: PreviewProvider {
    static var previews: some View {
        
        InLevelPage()
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
