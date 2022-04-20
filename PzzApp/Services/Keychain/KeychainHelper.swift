//
//  KeychainHelper.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 25.03.2022.
//

import Foundation
import SwiftKeychainWrapper

struct KeychainHelper {
    private static let authUsername = "authUsername"
    private static let authPassword = "authPassword"
    private static let keychainAPIKey = "apiKey"
    private static let keychainUserID = "userID"

    static var apiKey: String? {
        get {
            KeychainWrapper.standard.string(forKey: Self.keychainAPIKey)
        } set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: Self.keychainAPIKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Self.keychainAPIKey)
            }
        }
    }

    static var userID: Int? {
        get {
            KeychainWrapper.standard.integer(forKey: Self.keychainUserID)
        } set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: Self.keychainUserID)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Self.keychainUserID)
            }
        }
    }

    static var username: String? {
        get {
            KeychainWrapper.standard.string(forKey: Self.authUsername)
        } set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: Self.authUsername)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Self.authUsername)
            }
        }
    }

    static var password: String? {
        get {
            KeychainWrapper.standard.string(forKey: Self.authPassword)
        } set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: Self.authPassword)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Self.authPassword)
            }
        }
    }
}

