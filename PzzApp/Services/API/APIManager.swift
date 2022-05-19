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
    var pizzas: URL { get }
    var snacks: URL { get }
    var deserts: URL { get }
    var drinks: URL { get }
    var sauces: URL { get }
    func fetchData(completion: @escaping ([[JSON]]) -> ())
}

final class APIManager: Fetch {
    
    private init() {}
    
    static let shared = APIManager()
    
    let serverPath = URL(string: "https://pzz.by/api/v1")!
    lazy var pizzas = URL(string: "\(serverPath)/pizzas")!
    lazy var snacks = URL(string: "\(serverPath)/snacks")!
    lazy var deserts = URL(string: "\(serverPath)/deserts")!
    lazy var drinks = URL(string: "\(serverPath)/drinks")!
    lazy var sauces = URL(string: "\(serverPath)/sauces")!
    lazy var products = [pizzas, snacks, deserts, drinks, sauces]
    var json = [[JSON]]()
    
    func fetchData(completion: @escaping ([[JSON]]) -> ()) {
        for (index, product) in products.enumerated() {
            getProducts(with: product) { [unowned self] array in
                json.append(array)
                print("#", index)
                if index == products.count - 1 {
                    completion(json)
                    print("###", json)
                }
            }
        }
//        print("count", products.count)
    }
    
    func getProducts(with url: URL, completion: @escaping ([JSON]) -> ()) {
        AF.request(url)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let data = JSON(data)["response"]["data"].arrayValue
                    completion(data)
                case .failure(_):
                    return
                }
            }
    }
}
