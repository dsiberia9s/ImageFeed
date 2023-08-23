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
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
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
        //assert(Thread.isMainThread)
        
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                return
            }
        } else {
            if lastCode == code {
                return
            }
        }
        
        lastCode = code
        
        //let zcode = "xxx"
        
        let request = authTokenRequest(code: code)
        
        let session = URLSession.shared
        let taskx = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    self.lastCode = nil
                    completion(.failure(error))
                }

                self.task = nil
            }
        }

        self.task = taskx
        taskx.resume()
    }
}
