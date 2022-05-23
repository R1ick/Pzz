//
//  Product.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 19.05.2022.
//

import Foundation

struct Product: Decodable, Comparable  {
    let id: Int?
    let title: String?
    let titleInner: String?
    let anonce: String?
    let price: Int?
    let bigPrice: Double?
    let mediumPrice: Double?
    let bigWeight: String?
    let mediumWeight: String?
    let photoSmall: String?
    let publicImages: PublicImage?
    
    static func < (lhs: Product, rhs: Product) -> Bool {
        guard let lPrice = lhs.price, let rPrice = rhs.price else { return false }
        return lPrice > rPrice
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        guard let lid = lhs.title, let rid = rhs.title else { return false }
        return lid == rid
    }
}
