//
//  Settings.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 01.04.2022.
//

import Foundation
import RealmSwift

@objc enum OrderTime: Int, RawRepresentable, RealmEnum, CaseIterable {
    case at45
    case at60
    case pre
    
    var raw: String {
        switch self {
        case .at45: return "В течении 45 минут"
        case .at60: return "В течении 60 минут"
        case .pre: return "Предзаказ"
        }
    }
}

@objc enum Delivery: Int, RawRepresentable, RealmEnum, CaseIterable {
    case normal
    case withoutContact
    
    var raw: String {
        switch self {
        case .normal: return "Привезите как обычно"
        case .withoutContact: return  "Доставка без контакта с курьером"
        }
    }
}

@objc enum PaymentMethod: Int, RawRepresentable, RealmEnum, CaseIterable {
    case cash
    case card
    case online
    case halva
    
    var raw: String {
        switch self {
        case .cash:
            return "Наличными"
        case .card:
            return "Картой"
        case .online:
            return "Онлайн"
        case .halva:
            return "Халва"
        }
    }
}
