//
//  ResponseData.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 19.05.2022.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let error: Bool?
    let code: Int?
    let response: ResponseData<T>?
    let meta: String?
}

struct ResponseData<T: Decodable>: Decodable {
    let data: T?
}
