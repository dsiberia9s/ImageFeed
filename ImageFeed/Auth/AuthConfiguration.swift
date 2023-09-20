//
//  Constants.swift
//  ImageFeed
//
//  Created by Dmitrii on 30.07.2023.
//

import Foundation

let accessKey = "8UKlphCvOmLFEIqZbA75Kqb3HRE3KY0tCbMB6e3b6bE"
let secretKey = "N6_2BQRvGIRXM8_HCDXQKWEn4MZxSsj2zI5-PvcnCLw"
let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
let accessScope = "public+read_user+write_likes"

let defaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

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
