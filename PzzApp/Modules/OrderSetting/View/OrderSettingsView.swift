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
    
    @State var selectedDate: Date?
    @State var showDatePicker: Bool = false
    @State var isWarning: Bool = false
    
    let storage/*: SettingsStorable*/ = StorageService.shared
    
    var body: some View {
        VStack {
            CustomNavView("Настройки")
                .navigationBarTitleDisplayMode(.inline)
            Spacer()
            List {
                Section("Время доставки") {
                    SettingsCell(title: "Как можно быстрее", selected: settings.time == .at45 || settings.time == .at60)
                        .onTapGesture {
                            showDatePicker = false
                            storage.updateOrderSettings(time: .at45, preOrder: nil)
                        }
                    SettingsCell(title: "Предзаказ", selected: settings.time == .pre)
                        .onTapGesture {
                            if let preOrder = settings.preOrder {
                                storage.updateOrderSettings(time: .pre, preOrder: preOrder)
                                selectedDate = settings.preOrder
                            } else {
                                storage.updateOrderSettings(time: .pre)
                            }
                            showDatePicker.toggle()
                        }
                    if showDatePicker {
                        DatePickerWithButtons(showDatePicker: $showDatePicker, savedDate: $selectedDate, selectedDate: selectedDate ?? Date())
                            .frame(height: 400)
                        //                            .animation(.linear, value: showDatePicker)
//                            .transition(.opacity)
                    }
                }
                Section("Доставка") {
                    SettingsCell(title: "Привезти как обычно", selected: settings.delivery == .normal)
                        .onTapGesture {
                            storage.updateOrderSettings(delivery: .normal)
                        }
                    SettingsCell(title: "Доставка без контакта с курьером", selected: settings.delivery == .withoutContact)
                        .onTapGesture {
                            storage.updateOrderSettings(delivery: .withoutContact)
                        }
                }
                Section("Способ оплаты") {
                    SettingsCell(title: "Наличными", selected: settings.payment == .cash)
                        .onTapGesture {
                            storage.updateOrderSettings(payment: .cash)
                        }
                    SettingsCell(title: "Картой", selected: settings.payment == .card)
                        .onTapGesture {
                            storage.updateOrderSettings(payment: .card)
                        }
                    SettingsCell(title: "Онлайн", selected: settings.payment == .online)
                        .onTapGesture {
                            isWarning = true
                            //                            storage.updateOrderSettings(payment: .online)
                        }
                    SettingsCell(title: "Халва", selected: settings.payment == .halva)
                        .onTapGesture {
                            isWarning = true
                            //                            storage.updateOrderSettings(payment: .halva)
                        }
                }
            }
            .alert(isPresented: $isWarning) {
                Alert(title: Text("Функция находится в разработке"),
                      dismissButton: .default(Text("ОК")))
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


