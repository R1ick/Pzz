//
//  HistoryCell.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 18.04.2022.
//

import SwiftUI

struct HistoryCell: View {
    var order: Order
    
    var body: some View {
        HStack {
            TextMalina("\(order.date.formatted(date: .numeric, time: .omitted))\n\(order.date.formatted(date: .omitted, time: .shortened))", size: 16)
            List {
                ForEach(order.products) { product in
                    VStack(alignment: .leading) {
                        TextMalina("\(product.name) *\(product.count)", size: 14, color: .orange, alignment: .leading)
                        TextMalina("\(String(format: "%.2f",product.price))", size: 14, alignment: .leading)
                    }
                    .padding(.leading)
                }
                TextMalina("Итого: \(String(format: "%.2f", order.total))p.", size: 16, color: .green)
            }
            .padding([.top, .bottom], -20)
            .cornerRadius(12)
        }
        .listRowBackground(Color(#colorLiteral(red: 1, green: 0.6389834881, blue: 0.4692313671, alpha: 1).withAlphaComponent(0.5)))
        .cornerRadius(12)
    }
}
