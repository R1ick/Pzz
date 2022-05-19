//
//  DatePickerWithButtons.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 19.04.2022.
//

import SwiftUI

struct DatePickerWithButtons: View {
    
    let storage/*: SettingsStorable*/ = StorageService.shared
    
    @Binding var showDatePicker: Bool
    @Binding var savedDate: Date?
    @State var selectedDate: Date = Date()
    
    var body: some View {
        ZStack {
            Color(.white)
            
            VStack {
                DatePicker("Picker", selection: $selectedDate, in: Date()...)
                    .environment(\.locale, Locale.init(identifier: "ru"))
                    .datePickerStyle(GraphicalDatePickerStyle())
                Divider()
                HStack {
                    Button(action: {
                        storage.updateOrderSettings(time: .at45)
                        showDatePicker = false
                    }, label: {
                        TextMalina("Отменить", size: 16, color: .red)
                    })
                    Spacer()
                    Button(action: {
                        savedDate = selectedDate
                        storage.updateOrderSettings(time: .pre, preOrder: selectedDate)
                        showDatePicker = false
                    }, label: {
                        TextMalina("Готово", size: 16)
                    })
                }
                .padding(.horizontal)
            }
            .padding()
            .background(
                Color.white
                    .cornerRadius(30)
            )
        }
    }
}
