//
//  tessstt.swift
//  DSGameKanz
//
//  Created by Lujain Alrugabi on 08/12/2025.
//

import SwiftUI

struct TestImageView: View {
    var body: some View {
        ZStack {
            

            Image("RoadMapp")   // ← EXACT name in Assets
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    TestImageView()
}
