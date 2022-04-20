//
//  CustomNavView.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 14.04.2022.
//

import SwiftUI

struct CustomNavView: View {
    init(_ title: String = "755-66-55") {
        self.title = title
    }
    
    var title: String
    
    var body: some View {
        ZStack {
            Image("headerBg")
                .resizable()
                .frame(height: 90)
            HStack {
                Spacer()
                Spacer()
                TextMalina(title, size: 30, color: .white)
                Spacer()
                TextMalina("45", size: 30, color: .white)
                    .padding()
            }
            .padding(.top)
            .padding(.top)
        }
        .frame(height: 90)
    }
}
struct CustomNavView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavView()
    }
}
