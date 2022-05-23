//
//  UserInfo.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 24.03.2022.
//

import Foundation
import RealmSwift

@objcMembers final class UserInfo: Object, ObjectKeyIdentifiable {
    @objc dynamic var name: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var comment: String = ""
    @objc dynamic var currentAdressID: Int = 0
    dynamic var orderSettings: OrderSettings? = OrderSettings()
    var addresses = List<Adress>()
    var history = List<Order>()
}
