//
//  BasketElement.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 31.03.2022.
//

import Foundation
import RealmSwift

@objcMembers final class BasketElement: Object, ObjectKeyIdentifiable {
    @objc dynamic var name: String = ""
    @objc dynamic var size: String = ""
    @objc dynamic var count: Int = 0
    @objc dynamic var onePrice: Double = 0.0
    @objc dynamic var price: Double = 0.0
}
