//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Dmitrii on 01.08.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    // private let userDefaults = UserDefaults.standard
    private let tokenKey = "accessToken"
    
    var token: String? {
        get {
            //return userDefaults.string(forKey: tokenKey)
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        
        set {
            //userDefaults.set(newValue, forKey: tokenKey)
            guard let token = newValue else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
                return
            }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: tokenKey)
            guard isSuccess else {
                return
            }
        }
    }
}
