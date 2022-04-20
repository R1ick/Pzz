//
//  TextMalina.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 14.04.2022.
//

import SwiftUI

struct TextMalina: View {
    init(_ text: String, size: CGFloat, color: Color = .black, alignment: TextAlignment = .center) {
        self.text = text
        self.size = size
        self.color = color
        self.alignment = alignment
    }
    
    var text: String
    var size: CGFloat
    var color: Color
    var alignment: TextAlignment
    
    var body: some View {
        Text(text)
            .multilineTextAlignment(alignment)
            .fixedSize(horizontal: false, vertical: true)
            .font(Font.custom("ALS Malina Regular", size: size))
            .foregroundColor(color)
    }
}

