//
//  ImageListResponse.swift
//  ImageFeed
//
//  Created by Dmitrii on 27.08.2023.
//

import Foundation

enum DateError: Error {
    case invalidDateFormat
}

struct Response: Codable {
    let photo: PhotoResult
}

struct UrlResult: Codable {
    let thumb: URL?
    let full: URL?
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: Date?
    let width: Int
    let height: Int
    let description: String?
    let urls: UrlResult
    let likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case urls
        case likedByUser = "liked_by_user"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        urls = try container.decode(UrlResult.self, forKey: .urls)
        likedByUser = try container.decode(Bool.self, forKey: .likedByUser)
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        let dateFormatter = ISO8601DateFormatter()
        
        if let date = dateFormatter.date(from: createdAtString) {
            createdAt = date
        } else {
            throw DateError.invalidDateFormat
        }
    }
}
