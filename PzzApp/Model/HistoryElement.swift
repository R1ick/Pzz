//
//  HistoryElement.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 18.04.2022.
//

import Foundation
import RealmSwift

@objcMembers final class HistoryElement: Object, ObjectKeyIdentifiable {
    @objc dynamic var name: String = ""
    @objc dynamic var count: Int = 0
    @objc dynamic var price: Double = 0.0
}
