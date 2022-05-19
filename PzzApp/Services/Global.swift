//
//  Global.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 24.03.2022.
//

import Foundation
import SwiftUI

//MARK: Constants
final class Global {
    static func mainFontWithSize(size: CGFloat) -> UIFont {
         let font = UIFont(name: "ALS Malina Regular", size: size)!
         return font
    }
    static var currentUser: User = User()
}

final class CurrentAdress: ObservableObject {
    init() {
        guard let info = Global.currentUser.userInfo else { return }
        let adresses = info.addresses
        for adress in adresses {
            print("user", Global.currentUser)
            if adress.id == info.currentAdressID {
                self.adress = adress
            }
        }
    }
    
    @Published var adress: Adress = Adress()
}

