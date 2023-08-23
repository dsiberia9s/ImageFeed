//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dmitrii on 20.08.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    struct ProfileResult: Codable {
        var id: String
        var updatedAt: String
        var username: String
        var firstName: String
        var lastName: String
        var twitterUsername: String?
        var portfolioUrl: URL?
        var bio: String?
        var location: String?
        var totalLikes: Int
        var totalPhotos: Int
        var totalCollections: Int
        var followedByUser: Bool
        var downloads: Int
        var uploadsRemaining: Int
        var instagramUsername: String?
        var email: String
        var links: UserLinks
        
        struct UserLinks: Codable {
            var `self`: String
            var html: String
            var photos: String
            var likes: String
            var portfolio: String
        }
        
        enum CodingKeys: String, CodingKey {
            case id
            case updatedAt = "updated_at"
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case twitterUsername = "twitter_username"
            case portfolioUrl = "portfolio_url"
            case bio
            case location
            case totalLikes = "total_likes"
            case totalPhotos = "total_photos"
            case totalCollections = "total_collections"
            case followedByUser = "followed_by_user"
            case downloads
            case uploadsRemaining = "uploads_remaining"
            case instagramUsername = "instagram_username"
            case email
            case links
        }
    }
    
    struct Profile {
        var username: String
        var name: String
        var loginName: String
        var bio: String
        
        init(profile: ProfileResult) {
            self.username = profile.username
            self.name = "\(profile.firstName) \(profile.lastName)"
            self.loginName = "@" + profile.username
            self.bio = profile.bio ?? ""
        }
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let defaultBaseURL = defaultBaseURL else {
            return
        }
        
        let url = defaultBaseURL.appendingPathComponent("/me")
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    let profile = Profile(profile: profileResult)
                    self.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
