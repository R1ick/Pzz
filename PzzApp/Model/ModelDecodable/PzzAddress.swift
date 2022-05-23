//
//  PzzAddress.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 23.05.2022.
//

import Foundation

struct PzzAddress: Decodable {
    let id: Int?
    let streetId: Int?
    let houseId: Int?
    let manufactureTypes: String?
    let clientPhone: String?
    let flat: String?
    let entrance: String?
    let floor: String?
    let intercom: String?
    let createdAt: String?
    let updatedAt: String?
    let fullAddress: String?
    let active: Int?
    let street: Street?
    let house: House?
}
