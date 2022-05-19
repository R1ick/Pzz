//
//  AdressesList.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 17.04.2022.
//

import SwiftUI
import RealmSwift

struct AdressesList: View {
    @EnvironmentObject var user: User
    @ObservedObject var selected: CurrentAdress
    @ObservedRealmObject var info: UserInfo

    @State var alertPresent: Bool = false
    @State var isActive: Bool = false
    
    let storage: AdressStorable = StorageService.shared
    
    var body: some View {
        List {
            Section {
                NavigationLink(destination: AddAdressView(selected: selected, source: .add).environmentObject(user)) {
                    TextMalina("Добавить адрес", size: 20, color: .orange)
                }
            }
            if info.addresses.count  == 0 {
                HStack {
                    Spacer()
                    VStack {
                        TextMalina("Ooops...Тут пусто", size: 24)
                        Image("bottom-pzz")
                            .resizable()
                            .frame(width: 250, height: 250, alignment: .center)
                    }
                    Spacer()
                }
            } else {
                Section("Адреса") {
                    ForEach(info.addresses) { item in
                        ZStack {
                            NavigationLink(destination: AddAdressView(street: item.street,
                                                                      building: item.building,
                                                                      entrance: item.entrance,
                                                                      stage: item.stage,
                                                                      flat: item.flat,
                                                                      buzzer: item.buzzer,
                                                                      selected: selected,
                                                                      sourceAdress: item,
                                                                      source: .edit).environmentObject(user), isActive: $isActive) { Text("") }.disabled(!isActive)
                            HStack {
                                AddressCell(adress: item, selected: storage.isAdressesMatch(selected.adress, item))
                                Spacer()
                            }
                        }
                        .onTapGesture {
                            selected.adress = item
                            storage.changeCurrentAdress(with: item, for: user)
                        }
                        
                        .listRowBackground(Color(#colorLiteral(red: 1, green: 0.6389834881, blue: 0.4692313671, alpha: 1).withAlphaComponent(0.5)))
                        .swipeActions {
                            Button {
                                if info.currentAdressID == item.id {
                                    alertPresent = true
                                    return
                                }
                                if info.addresses.count < 2 {
                                    alertPresent = true
                                    return
                                } else {
                                    storage.deleteAdress(adress: item)
                                }
                            } label: {
                                TextMalina("Удалить", size: 12)
                            }
                            .tint(.red)
                            
                            Button {
                                isActive = true
                            } label: {
                                TextMalina("Редактировать", size: 20, color: .orange)
                            }
                            .tint(.orange)
                          
                        }
                        .animation(.easeOut, value: alertPresent)
                        
                        .alert(isPresented: $alertPresent) {
                            Alert(title: Text("Внимание!"),
                                  message: Text("Вы не можете удалить единственный или выбранный адрес."),
                                  dismissButton: .default(Text("ОК")))
                        }
                    }
                }
                .onAppear {
                    print("SELECTED", selected.adress)
                    isActive = false
                    UITableView.appearance().backgroundColor = .clear
                }
            }
        }
    }
}

