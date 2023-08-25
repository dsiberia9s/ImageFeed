//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dmitrii on 20.08.2023.
//

import Foundation

final class ProfileService {
    private init() { }
    static let shared = ProfileService()

    private(set) var profile: Profile?
    
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
