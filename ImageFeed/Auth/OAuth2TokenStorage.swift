//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Dmitrii on 01.08.2023.
//

import Foundation

class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "accessToken"
    
    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}
