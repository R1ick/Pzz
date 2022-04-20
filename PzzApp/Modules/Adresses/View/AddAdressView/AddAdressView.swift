//
//  AddAdressView.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 16.04.2022.
//

import SwiftUI

struct AddAdressView: View {
    @State var street: String = ""
    @State var building: String = ""
    @State var entrance: String = ""
    @State var stage: String = ""
    @State var flat: String = ""
    @State var buzzer: String = ""
    
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentation
    
    let storage: Storage = StorageService.shared
    var closure: ((Adress) -> ())?
    var item = GridItem(.flexible(minimum: 130, maximum: 250), spacing: 16)
    
    var body: some View {
        VStack {
            CustomNavView()
                .navigationBarTitleDisplayMode(.inline)
            TextMalina("Добавить новый адрес", size: 24)
                .padding(.trailing, 100)
            LazyVGrid(columns: [item]) {
                HStack {
                    TextAndTF(text: "Улица",
                          tfPlaceholder: "Независимости",
                          tfText: $street)
                .frame(width: 420)
                }
                HStack {
                    TextAndTF(text: "Дом",
                              tfPlaceholder: "1",
                              tfText: $building)
                    .frame(width: 130)
                    TextAndTF(text: "Подъезд",
                              tfPlaceholder: "1",
                              tfText: $entrance)
                    .frame(width: 130)
                    TextAndTF(text: "Этаж",
                              tfPlaceholder: "3",
                              tfText: $stage)
                    .frame(width: 130)
                }
                HStack {
                    TextAndTF(text: "Квартира",
                              tfPlaceholder: "10",
                              tfText: $flat)
                    .frame(width: 150)
                    TextAndTF(text: "Домофон",
                              tfPlaceholder: "10",
                              tfText: $buzzer)
                    .frame(width: 150)
                }
            }
            .padding()
            Spacer()
            Button("Сохранить") {
                guard let closure = closure else { return }
                let adress = Adress()
                adress.street = street
                adress.building = building
                adress.entrance = entrance
                adress.stage = stage
                adress.flat = flat
                adress.buzzer = buzzer
                closure(adress)
                storage.saveAdressFor(user, adress: adress)
                presentation.wrappedValue.dismiss()
            }
            .font(Font.custom("ALS Malina Regular", size: 20))
            .foregroundColor(.orange)
            Spacer()
        }
        .ignoresSafeArea()
    }
}

//struct AddAdressView_Previews: PreviewProvider {
//    static var previews: some View {
////        AddAdressView(isDetail: $isSome)
//    }
//}

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
