//
//  APIPaths.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 20.05.2022.
//

import Foundation

enum APIPaths: String {
    case server = "https://pzz.by/api/v1/"
    case pizzas = "https://pzz.by/api/v1/pizzas"
    case snacks = "https://pzz.by/api/v1/snacks"
    case desserts = "https://pzz.by/api/v1/desserts"
    case drinks = "https://pzz.by/api/v1/drinks"
    case sauces = "https://pzz.by/api/v1/sauces"
    case getPassword = "https://pzz.by/api/v1/clients/password"
    case changePassword = "https://pzz.by/api/v1/clients/new-password"
    case me = "https://pzz.by/api/v1/clients/me"
    case login = "https://pzz.by/api/v1/clients/login"
    case logout = "https://pzz.by/api/v1/clients/logout"
    case deleteAddress = "https://pzz.by/api/v1/clients/forget-address"
    case settings = "https://pzz.by/api/v1/settings"
}
