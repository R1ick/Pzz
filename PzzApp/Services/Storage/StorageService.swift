//
//  StorageService.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 25.03.2022.
//

import Foundation
import RealmSwift

let realm = try! Realm()
var notificationToken = NotificationToken()

final class StorageService: Storable, UserInfoStorable, HistoryStorable, SettingsStorable, AdressStorable {
    
    private init() {
        user = Global.currentUser
    }
    
    var user: User?
    
    static let shared = StorageService()
    
    //MARK: Clean DB
    func cleanDatabase() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(#function, "error")
        }
    }
    
    //MARK: Save / delete objects
    func save(_ object: Object) {
        if let user = object as? User {
            try! realm.write {
                realm.add(user)
            }
            Global.currentUser = user
        }
        if let food = object as? BasketElement {
            checkFood(food)
        }
        if let adress = object as? Adress {
            try! realm.write {
                realm.add(adress)
            }
        }
    }
    func delete(_ object: Object) {
        if let user = object as? User {
            try! realm.write {
                realm.delete(user)
            }
        }
        if let food = object as? BasketElement {
            try! realm.write {
                realm.delete(food)
            }
        }
        if let adress = object as? Adress {
            try! realm.write {
                realm.delete(adress)
            }
        }
    }
    
    //MARK: AdressStorable
    func saveAdressFor(_ user: User, adress: Adress) {
        try! realm.write {
            user.userInfo?.currentAdressID = Int(adress.id)
            user.userInfo?.addresses.append(adress)
        }
    }
    
    func deleteAdress(adress: Adress) {
            try! realm.write {
                let item = realm.objects(Adress.self).filter { [unowned self] in
                    self.isAdressesMatch($0, adress)
                }
                realm.delete(item)
            }
    }
    
    func editAdress(adress: Adress, with: Adress) {
        try! realm.write {
            adress.street = with.street
            adress.building = with.building
            adress.entrance = with.entrance
            adress.stage = with.stage
            adress.flat = with.flat
            adress.buzzer = with.buzzer
        }
    }
    
    func isAdressesMatch(_ one: Adress, _ two: Adress) -> Bool {
        return one.building == two.building && one.street == two.street && one.entrance == two.entrance && one.stage == two.stage && one.flat == two.flat && one.buzzer == two.buzzer
    }
    
    func changeCurrent(with adress: Adress) {
        try! realm.write {
            user?.userInfo?.currentAdressID = Int(adress.id)
        }
    }
    
    //MARK: History
    func savetoHistory(_ order: Order) {
        if realm.isInWriteTransaction {
            user?.userInfo?.history.append(order)
        } else {
            try! realm.write {
                user?.userInfo?.history.append(order)
            }
        }
    }
    
    func deleteFromHistory(_ order: Order) {
        try! realm.write {
            realm.delete(order)
        }
    }
    
    //MARK: A
    func cleanBusket() {
        let basket = realm.objects(BasketElement.self)
        for item in basket {
            if realm.isInWriteTransaction {
                realm.delete(item)
            } else {
                try! realm.write {
                    realm.delete(item)
                }
            }
        }
    }
    
    //MARK: UserInfoStorable
    func createUserInfo(for user: User) {
        let orderSettings = OrderSettings()
        orderSettings.time = .at45
        let userInfo = UserInfo()
        userInfo.name = "Username"
        userInfo.orderSettings = orderSettings
        let newUser = User()
        newUser.login = user.login
        newUser.password = user.password
        newUser.userInfo = userInfo
        try! realm.write {
            realm.delete(user)
            realm.add(newUser)
        }
        Global.currentUser = newUser
    }
    
    func updateUserInfo(for user: User, with properties: [UserProperties]) {
        for property in properties {
            try! realm.write {
                switch property {
                case .name(let name):
                    user.userInfo?.name = name
                case .phone(let phone):
                    user.userInfo?.phone = phone
                case .comment(let comment):
                    user.userInfo?.comment = comment
                }
            }
        }
    }
    
    //MARK: Update order settings
    func updateOrderSettings(time: OrderTime? = nil, delivery: Delivery? = nil, payment: PaymentMethod? = nil, preOrder: Date? = nil) {
        let settings = realm.objects(OrderSettings.self)
        if !settings.isEmpty {
            guard let def = settings.first else { return }
            try! realm.write {
                if let time = time {
                    def.time = time
                }
                if let delivery = delivery {
                    def.delivery = delivery
                }
                if let payment = payment {
                    def.payment = payment
                }
                if let preOrder = preOrder {
                    def.preOrder = preOrder
                }
            }
        }
    }
    
    //MARK: Private functions
    private func checkFood(_ candidat: BasketElement) {
        let foods = realm.objects(BasketElement.self)
        for food in foods {
            if food.name == candidat.name, food.size == candidat.size {
                try! realm.write {
                    food.count += 1
                }
                return
            }
        }
        try! realm.write {
            realm.add(candidat)
        }
    }
    
    private func updateCurrentUser() {
        notificationToken = (user?.observe { [weak self] change in
            switch change {
            case .error(_):
                return
            case .change(_, _):
                return
            case .deleted:
                self?.user = Global.currentUser
            }
        })!
    }
        
}

enum UserProperties {
    case name(String)
    case phone(String)
    case comment(String)
}
