//
//  SettingsCell.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 19.04.2022.
//

import SwiftUI

struct SettingsCell: View {
    var title = "test"
    var selected = false
    
    var body: some View {
        HStack {
            CircleShape(fill: selected)
            TextMalina(title, size: 16, alignment: .leading)
                    .padding()
        }
        .frame(height: 50)
    }
}


struct SettingsCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCell(title: "cell", selected: true)
    }
}


struct CircleShape: View {
    
    var fill = false
    
    var body: some View {
        Circle()
            .foregroundColor(.black)
            .frame(width: 20)
            .overlay(
                Circle()
                    .foregroundColor(.white)
                    .frame(width: fill ? 0 : 15)
            )
    }
}
