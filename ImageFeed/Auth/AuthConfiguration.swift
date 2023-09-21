//
//  Constants.swift
//  ImageFeed
//
//  Created by Dmitrii on 30.07.2023.
//

import Foundation

struct AuthConfiguration {
    let AccessKey: String
    let SecretKey: String
    let RedirectURI: String
    let AccessScope: String
    let DefaultBaseURL: URL
    let AuthURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.AccessKey = accessKey
        self.SecretKey = secretKey
        self.RedirectURI = redirectURI
        self.AccessScope = accessScope
        self.DefaultBaseURL = defaultBaseURL
        self.AuthURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: accessKey,
            secretKey: secretKey,
            redirectURI: redirectURI,
            accessScope: accessScope,
            authURLString: UnsplashAuthorizeURLString,
            defaultBaseURL: defaultBaseURL
        )
    }
}
