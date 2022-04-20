//
//  StorageProtocols.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 18.04.2022.
//

import RealmSwift

protocol Storable {
    func cleanDatabase()
    func save(_ object: Object)
    func delete(_ object: Object)
}

protocol UserInfoStorable {
    func createUserInfo(for user: User)
    func updateUserInfo(for user: User, with properties: [UserProperties])
}

protocol HistoryStorable {
    func savetoHistory(_ order: Order)
    func deleteFromHistory(_ order: Order)
}

protocol SettingsStorable {
    func updateOrderSettings(time: OrderTime?, delivery: Delivery?, payment: PaymentMethod?, preOrder: Date?)
}

protocol AdressStorable {
    func saveAdressFor(_ user: User, adress: Adress)
    func deleteAdress(adress: Adress)
    func editAdress(adress: Adress, with: Adress) 
    func changeCurrent(with adress: Adress)
    func isAdressesMatch(_ one: Adress, _ two: Adress) -> Bool
}
