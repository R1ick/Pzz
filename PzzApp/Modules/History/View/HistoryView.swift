//
//  History.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 14.04.2022.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject var info: UserInfo
    
    var body: some View {
        VStack {
            CustomNavView("История")
            HStack {
                TextMalina("История заказов", size: 24)
                Spacer()
            }
            .padding(.leading)
            if info.history.count == 0 {
                HStack {
                    Spacer()
                    VStack {
                        TextMalina("Ooops...Тут пусто", size: 24)
                        Image("bottom-pzz")
                            .resizable()
                            .frame(width: 250, height: 250, alignment: .center)
                    }
                    Spacer()
                }
                .padding(.top, 32)
            } else {
                List {
                    Section("Заказы") {
                        ForEach(info.history) { cell in
                            HistoryCell(order: cell)
                                .frame(height: 100)
                        }
                    }
                    .onAppear {
                        UITableView.appearance().backgroundColor = #colorLiteral(red: 1, green: 0.6389834881, blue: 0.4692313671, alpha: 1).withAlphaComponent(0.3)
                    }
                    .onDisappear() {
                        UITableView.appearance().backgroundColor = .clear
                    }
                }
                .onAppear {
                    UITableView.appearance().backgroundColor = .clear
                }
            }
            Spacer(minLength: 50)
        }
        .ignoresSafeArea()
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(info: Global.currentUser.userInfo!)
    }
}
