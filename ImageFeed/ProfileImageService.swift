//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Dmitrii on 20.08.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private (set) var avatarURL: String?
    
    struct ProfileImage: Codable {
        var profileImage: ProfileImage
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
        
        struct ProfileImage: Codable {
            var medium: String
        }
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let defaultBaseURL = defaultBaseURL else {
            return
        }
        
        let url = defaultBaseURL.appendingPathComponent("/users/\(username)")
        var request = URLRequest(url: url)
        
        guard let token = self.oauth2TokenStorage.token else {
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { (result: Result<ProfileImage, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.avatarURL = result.profileImage.medium
                    
                    guard let profileImageURL = self.avatarURL else {
                        let error = NSError(domain: "ProfileImageService", code: 0, userInfo: [NSLocalizedDescriptionKey: "profileImageURL is nil"])
                        completion(.failure(error))
                        return
                    }
                    
                    NotificationCenter.default.post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL]
                    )
                    
                    completion(.success(profileImageURL))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

}
