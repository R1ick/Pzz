//
//  Adresses.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 14.04.2022.
//

import SwiftUI
import RealmSwift

struct AdressesView: View {
    @StateObject var current = CurrentAdress()
    
    @ObservedRealmObject var info: UserInfo
    @EnvironmentObject var user: User
    
    let storage = StorageService.shared
    
    var body: some View {
        if let userInfo = user.userInfo,
           $info.wrappedValue.name == userInfo.name, $info.wrappedValue.phone == userInfo.phone {
            VStack {
                CustomNavView("Адреса")
                    .navigationBarTitleDisplayMode(.inline)
                AdressesList(selected: current, info: info)
            }
            .ignoresSafeArea()
        } else {
            VStack {
                CustomNavView("Адреса")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

