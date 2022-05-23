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
    @State var addresses: [Adress] = []
    
    private let storage: AdressStorable = StorageService.shared
    private let apiManager: Fetch = APIManager()
    
    var body: some View {
        List {
            Section {
                NavigationLink(destination: AddAdressView(selected: selected, source: .add).environmentObject(user)) {
                    TextMalina("Добавить адрес", size: 20, color: .orange)
                }
            }
            if addresses.count  == 0 {
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
                    ForEach(addresses) { item in
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
                                    deleteAddress(item)
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
                    isActive = false
                    UITableView.appearance().backgroundColor = .clear
//                    getProfileInfo()
                }
            }
        }
        .padding(.bottom, 70)
        .onAppear {
            getProfileInfo()
        }
    }
    
    func getProfileInfo() {
        apiManager.getProfileInfo { profile, error in
            if let error = error {
                print(error)
            }
            if let profile = profile, let addresses = profile.addresses {
                if addresses.count == 0 {
                    for adress in info.addresses {
                        storage.deleteAdress(adress: adress)
                    }
                }
                for address in addresses {
                    let converted = convertePzzToRealmAddress(address)
                    self.addresses.append(converted)
                }
            }
        }
    }
    
    func deleteAddress(_ adress: Adress) {
        apiManager.getProfileInfo { profile, error in
            if let error = error {
                print(error)
            }
            if let profile = profile, let addresses = profile.addresses {
                for address in addresses {
                    let converted = convertePzzToRealmAddress(address)
                    if storage.isAdressesMatch(converted, adress) {
                        let id = address.id ?? 0
                        apiManager.deleteAddress(id: id) { string, error in
                            if let _ = error { print(error) }
                            if let string = string, let index = getIndexOf(address: adress) {
                                self.addresses.remove(at: index)
                                print(string)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getIndexOf(address: Adress) -> Int? {
        for (index, adr) in addresses.enumerated() {
            if storage.isAdressesMatch(address, adr) {
                return index
            }
        }
        return nil
    }
    
    private func convertePzzToRealmAddress(_ address: PzzAddress) -> Adress {
        let adr = Adress()
        adr.street = address.street?.title ?? ""
        adr.building = address.house?.title ?? ""
        adr.entrance = address.entrance ?? ""
        adr.stage = address.floor ?? ""
        adr.flat = address.flat ?? ""
        adr.buzzer = address.intercom ?? ""
        return adr
    }
}

