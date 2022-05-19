//
//  AdressesCell.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 17.04.2022.
//

import SwiftUI
import RealmSwift

struct AddressCell: View {
    
    @ObservedRealmObject var adress: Adress
    
    var selected: Bool = false
    
    var body: some View {
        SettingsCell(title: "\(adress.street), \(adress.building) - \(adress.flat)", selected: selected)
            .listRowBackground(Color(#colorLiteral(red: 1, green: 0.6389834881, blue: 0.4692313671, alpha: 1).withAlphaComponent(0.5)))
            .padding(.leading)
            .frame(height: 90)
    }
}
