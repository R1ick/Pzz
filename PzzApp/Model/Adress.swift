//
//  Adress.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 24.03.2022.
//

import Foundation
import RealmSwift

@objcMembers final class Adress: Object, ObjectKeyIdentifiable {
    @objc dynamic var city: String = "Minsk"
    @objc dynamic var street: String = ""
    @objc dynamic var building: String = ""
    @objc dynamic var entrance: String = ""
    @objc dynamic var stage: String = ""
    @objc dynamic var flat: String = ""
    @objc dynamic var buzzer: String = ""
}
