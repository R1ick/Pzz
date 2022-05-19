//
//  User.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 24.03.2022.
//

import Foundation
import SwiftUI
import RealmSwift

@objcMembers final class User: Object {
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""
    dynamic var userInfo: UserInfo? = UserInfo()
}


