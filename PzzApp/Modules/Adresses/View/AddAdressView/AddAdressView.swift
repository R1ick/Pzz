//
//  AddAdressView.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 16.04.2022.
//

import SwiftUI

enum SaveActionButtonFrom {
    case add
    case edit
}

struct AddAdressView: View {
    @State var street: String = ""
    @State var building: String = ""
    @State var entrance: String = ""
    @State var stage: String = ""
    @State var flat: String = ""
    @State var buzzer: String = ""
    
    @ObservedObject var selected: CurrentAdress
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentation
    
    let storage: AdressStorable = StorageService.shared
    
    @State var sourceAdress: Adress?
    @State var source: SaveActionButtonFrom = .add
    
    var item = GridItem(.flexible(minimum: 130, maximum: 250), spacing: 16)
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomNavView()
                .navigationBarTitleDisplayMode(.inline)
            ScrollView {
                switch source {
                case .add:
                    TextMalina("Добавить новый адрес", size: 24)
                        .padding(.leading)
                case .edit:
                    TextMalina("Редактировать", size: 24)
                        .padding(.leading)
                }
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
                HStack {
                    Spacer()
                    Button("Сохранить") {
                        let adress = Adress()
                        adress.street = street
                        adress.building = building
                        adress.entrance = entrance
                        adress.stage = stage
                        adress.flat = flat
                        adress.buzzer = buzzer
                        switch source {
                        case .add:
                            storage.saveAdressFor(user, adress: adress)
                            storage.changeCurrentAdress(with: adress, for: user)
                            selected.adress = adress
                            
                        case .edit:
                            guard let sourceAdress = sourceAdress?.thaw() else { return }
                            storage.editAdress(adress: sourceAdress, with: adress)
                        }
                        presentation.wrappedValue.dismiss()
                    }
                    .font(Font.custom("ALS Malina Regular", size: 20))
                    .foregroundColor(.orange)
                    Spacer()
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}
