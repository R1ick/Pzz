//
//  Order.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 25.03.2022.
//

import Foundation
import RealmSwift

@objcMembers final class Order: Object, ObjectKeyIdentifiable {
    dynamic var date = Date()
    dynamic var total = 0.0
    dynamic var products = List<HistoryElement>()
}
