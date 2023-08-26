//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Dmitrii on 01.08.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let tokenKey = "accessToken"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        
        set {
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
