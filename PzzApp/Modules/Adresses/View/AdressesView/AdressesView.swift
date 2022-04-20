//
//  Adresses.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 14.04.2022.
//

import SwiftUI
import RealmSwift

struct AdressesView: View {
    
    @EnvironmentObject var user: User
    @State var adresses: [Adress] = []
    
    let storage = StorageService.shared
    var closure: ((Adress) -> ())?
    
    var body: some View {
        VStack {
            CustomNavView("Адреса")
                .navigationBarTitleDisplayMode(.inline)
            HStack {
                NavigationLink(destination: AddAdressView(closure: { adress in
                    adresses.append(adress)
                })
                    .environmentObject(user)) {
                        TextMalina("Добавить адрес", size: 16, color: .orange)
                }
                .padding(.leading)
                Spacer()
            }
            AdressesList(array: $adresses)
            .onAppear {
                print(adresses)
            }
        }
        .ignoresSafeArea()
    }
}
struct AdressesList: View {
    @Binding var array: [Adress]
    @State var alertPresent = false
    
    let storage: Storage = StorageService.shared
    
    var body: some View {
        List(0..<array.count) { item in
            AddressCell(title: "\(array[item].street), \(array[item].building) - \(array[item].flat)")
                .swipeActions {
                    Button("Tap") {
                        print(array[item])
                        print(item)
                    }
                    .tint(.green)
                    Button("Delete") {
                        if array.count > 1 {
                            array.remove(at: item)
                        } else {
                            alertPresent = true
                        }
                    }
                    .alert(isPresented: $alertPresent) {
                        Alert(title: Text("Внимание!"),
                              message: Text("Вы не можете удалить свой единственный адрес."),
                              dismissButton: .default(Text("Cancel")))
                    }
                    .tint(.red)
                }
        }
    }
}

struct AddressCell: View {
    var title: String
    
    var body: some View {
            VStack(alignment: .leading) {
                TextMalina(title, size: 18)
            }
            .listRowBackground(Color(#colorLiteral(red: 1, green: 0.6389834881, blue: 0.4692313671, alpha: 1).withAlphaComponent(0.5)))
            .padding(.leading)
            .frame(height: 90)
    }
}
