//
//  OrderSettings.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 11.04.2022.
//

import Foundation
import RealmSwift

@objcMembers final class OrderSettings: Object {
    @objc dynamic var time: OrderTime = .at45
    @objc dynamic var delivery: Delivery = .normal
    @objc dynamic var payment: PaymentMethod = .cash
    @objc dynamic var preOrder: Date? = nil
}
