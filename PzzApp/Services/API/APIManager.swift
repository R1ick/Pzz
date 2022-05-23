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
    func getPassword(phone: String, completion: @escaping (String?, Error?) -> ())
    func login(phone: String, password: String, completion: @escaping (Profile?, Error?) -> ())
    func getProfileInfo(completion: @escaping (Profile?, Error?) -> ())
    func requestFoodImage(url: String, cell: ProductCell)
    func getProducts(completion: @escaping ([[Product]]?, Error?) -> ()) async
    func getDeliveryTime(completion: @escaping (String?, Error?) -> ())
    func deleteAddress(id: Int, completion: @escaping (String?, Error?) -> ())
}

final class APIManager: Fetch {
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private let decoder = JSONDecoder()
    lazy var products = [APIPaths.pizzas, APIPaths.snacks, APIPaths.desserts, APIPaths.drinks, APIPaths.sauces]
    var json = [[Product]]()
    
    //MARK: - Registration
    func getPassword(phone: String, completion: @escaping (String?, Error?) -> ()) {
        let link = APIPaths.getPassword.rawValue
        guard let url = URL(string: link) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = "phone=\(phone)".data(using: .utf8)
        
        AF.request(request)
            .validate()
            .responseData { response in
                guard let data = response.value else {
                    completion(nil, response.error)
                    print(#file, #line, response.error?.localizedDescription)
                    return
                }
                let message = JSON(data)["response"]["data"].stringValue
                completion(message, nil)
            }
    }
    
    //MARK: - Login
    func login(phone: String, password: String, completion: @escaping (Profile?, Error?) -> ()) {
        let link = APIPaths.login.rawValue
        guard let url = URL(string: link) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = "phone=\(phone)&password=\(password)".data(using: .utf8)
        
        AF.request(request)
            .validate()
            .responseDecodable(of: Response<Profile>.self, decoder: decoder) { response in
                guard let json = response.value,
                      let profile = json.response?.data else {
                    completion(nil, response.error)
                    print(#file, #line, response.error?.localizedDescription)
                    return
                }
                completion(profile, nil)
            }
    }
    
    //MARK: - Profile
    func getProfileInfo(completion: @escaping (Profile?, Error?) -> ()) {
        let link = APIPaths.me.rawValue
        
        AF.request(link)
            .validate()
            .responseDecodable(of: Response<Profile>.self, decoder: decoder) { response in
                guard let data = response.value,
                      let profile = data.response?.data
                else {
                    completion(nil, response.error)
                    print(#file, #line, response.error?.localizedDescription)
                    return
                }
                completion(profile, nil)
            }
    }
    
    //MARK: - Products
    func getProducts(completion: @escaping ([[Product]]?, Error?) -> ()) async {
        for (index, product) in products.enumerated() {
            guard let url = URL(string: product.rawValue) else { return }
            var array = [Product]()
            do {
                let data = try await afRequest(url: url)
                let json = try decoder.decode(Response<Array<Product>>.self, from: data)
                guard let prods = json.response?.data else { return }
                for prod in prods {
                    if prod.photoSmall == nil {
                        continue
                    } else {
                        array.append(prod)
                    }
                }
                self.json.append(array)
                if index == self.products.count - 1 {
                    completion(self.json, nil)
                }
            } catch let error {
                debugPrint(error)
                completion(nil, error)
            }
        }
    }
    
    func afRequest(url: URL) async throws -> Data {
        try await withUnsafeThrowingContinuation { continuation in
            AF.request(url, method: .get).validate().responseData { response in
                if let data = response.data {
                    continuation.resume(returning: data)
                    return
                }
                if let err = response.error {
                    continuation.resume(throwing: err)
                    return
                }
                fatalError("should not get here")
            }
        }
    }
    
    //MARK: - Addresses
    func getHouseId(for street: String, completion: @escaping (Int?, Error?) -> ()) {
        
    }
    func deleteAddress(id: Int, completion: @escaping (String?, Error?) -> ()) {
        let link = APIPaths.deleteAddress.rawValue
        guard let url = URL(string: link) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = "address_id=\(id)".data(using: .utf8)
        
        AF.request(request)
            .validate()
            .responseString { response in
                guard let json = response.value else {
                    completion(nil, response.error)
                    print(#file, #line, response.error)
                    return
                }
                completion(JSON(json)["response"]["data"].stringValue, nil)
            }
    }
    
    //MARK: - Food image
    func requestFoodImage(url: String, cell: ProductCell) {
        guard let url = URL(string: url) else { return }
        AF.request(url).responseImage { response in
            switch response.result {
            case .success(let data):
                cell.productImageView.image = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - Delivery time
    func getDeliveryTime(completion: @escaping (String?, Error?) -> ()) {
        let link = APIPaths.settings.rawValue
        
        AF.request(link)
            .validate()
            .responseData() { response in
                guard let data = response.value else {
                    completion(nil, response.error)
                    print(#file, #line, response.error?.localizedDescription)
                    return
                }
                guard let settings = JSON(data)["response"]["data"].array else {
                    completion(nil, response.error)
                    print(#file, #line, response.error?.localizedDescription)
                    return
                }
                for setting in settings {
                    if setting["settings_type"].stringValue == "pizzeria" || setting["settings_type"].stringValue == "general" {
                        if let bool = setting["is_delivery_45"].bool {
                            completion(bool ? "45" : "60", nil)
                            return
                        }
                        if let int = setting["is_delivery_45"].int {
                            completion(int == 1 ? "45" : "60", nil)
                            return
                        }
                    }
                }
            }
    }
}
