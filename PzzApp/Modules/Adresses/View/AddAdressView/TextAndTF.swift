//
//  TextAndTF.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 17.04.2022.
//

import SwiftUI

struct TextAndTF: View {
    var text: String
    var tfPlaceholder: String
    @Binding var tfText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            TextMalina(text, size: 16)
            TextField(tfPlaceholder, text: $tfText)
                .textFieldStyle(.roundedBorder)
                .cornerRadius(12)
                .font(Font.custom("ALS Malina Regular", size: 16))
        }
        .padding()
    }
}
