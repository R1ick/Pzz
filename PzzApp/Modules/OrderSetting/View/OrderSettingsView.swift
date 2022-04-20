//
//  OrderSettingsView.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 14.04.2022.
//

import SwiftUI
import RealmSwift

struct OrderSettingsView: View {
    
    @EnvironmentObject var settings: OrderSettings
    
    var body: some View {
        VStack {
            CustomNavView("Настройки")
                .navigationBarTitleDisplayMode(.inline)
            Spacer()
            List {
                Section("Время доставки") {
                    SettingsCell(title: "Как можно быстрее", selected: settings.time == .at45 || settings.time == .at60)
                    SettingsCell(title: "Предзаказ", selected: settings.time == .pre)
                }
                Section("Доставка") {
                    SettingsCell(title: "Привезти как обычно", selected: settings.delivery == .normal)
                    SettingsCell(title: "Доставка без контакта с курьером", selected: settings.delivery == .withoutContact)
                }
                Section("Способ оплаты") {
                    SettingsCell(title: "Наличными", selected: settings.payment == .cash)
                    SettingsCell(title: "Картой", selected: settings.payment == .card)
                    SettingsCell(title: "Онлайн", selected: settings.payment == .online)
                    SettingsCell(title: "Халва", selected: settings.payment == .halva)
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

struct OrderSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderSettingsView()
    }
}

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

struct CircleShape: View {
    
    var fill = false
    
    var body: some View {
        Circle()
            .foregroundColor(.black)
            .frame(width: 30)
            .overlay(
                Circle()
                    .foregroundColor(.white)
                    .frame(width: fill ? 0 : 25)
            )
    }
}
