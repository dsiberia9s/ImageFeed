//
//  ProfileResponse.swift
//  ImageFeed
//
//  Created by Dmitrii on 25.08.2023.
//

import Foundation

struct ProfileResult: Codable {
    var id: String
    var username: String
    var firstName: String
    var lastName: String
    var bio: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
