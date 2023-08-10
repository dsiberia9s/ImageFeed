//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Dmitrii on 31.07.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    internal let urlSession = URLSession.shared
    internal let tokenStorage = OAuth2TokenStorage()
    
    internal var authToken: String? {
        get {
            return tokenStorage.token
        }
        
        set {
            tokenStorage.token = newValue
        }
    }
    
    internal init() { }
    
    func fetchAuthToken(
    _ code: String,
    completion: @escaping (Result<String, Error>) -> Void
    ) {
        let request = authTokenRequest(code: code)
        
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
