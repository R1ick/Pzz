//
//  Array + [Product] subscript.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 23.05.2022.
//

import Foundation

extension Array where Element == [Product] {
    subscript (productType: ProductType) -> [Product] {
        get {
            var products = [Product]()
            for _ in self {
                switch productType {
                case .pizza:
                    products = self[0].sorted(by: <)
                case .snacks:
                    products = self[1].sorted(by: <)
                case .drinks:
                    products = self[3].sorted(by: <)
                case .deserts:
                    products = self[2].sorted(by: <)
                case .sauces:
                    products = self[4].sorted(by: <)
                }
            }
            return products
        }
    }
    
    func deleteAt(index: Int, for type: ProductType) -> [Product] {
        var products = [Product]()
        let array = self[type]
        for (idx, item) in array.enumerated() {
            if index == idx {
                continue
            }
            products.append(item)
        }
        return products
    }
}
