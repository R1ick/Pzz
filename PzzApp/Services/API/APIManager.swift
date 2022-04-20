//
//  APIManager.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 25.03.2022.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol Fetch {
    var serverPath: URL { get }
    var products: URL { get }
    func fetchData(with url: URL, completion: @escaping ([JSON]) -> ())
}

final class APIManager: Fetch {
    
    private init() {}
    
    static let shared = APIManager()
    
    let serverPath = URL(string: "http://localhost:3004")!
    let products = URL(string: "http://localhost:3004/products")!
    
    func fetchData(with url: URL, completion: @escaping ([JSON]) -> ()) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let data):
                let data = JSON(data).arrayValue
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
