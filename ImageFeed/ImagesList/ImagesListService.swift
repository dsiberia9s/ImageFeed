//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Dmitrii on 27.08.2023.
//

import Foundation

final class ImagesListService {
    private init() { }
    static let shared = ImagesListService()
    private let itemsPerPage: Int = 10
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    var busy: Bool = false
    
    struct Photo: Codable {
        let id: String
        let size: CGSize
        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: String?
        let largeImageURL: String?
        let isLiked: Bool
        
        init(photoResult: PhotoResult) {
            self.id = photoResult.id
            self.size = CGSize(width: photoResult.width, height: photoResult.height)
            self.createdAt = photoResult.createdAt
            self.welcomeDescription = photoResult.description
            self.thumbImageURL = photoResult.urls.thumb?.absoluteString
            self.largeImageURL = photoResult.urls.full?.absoluteString
            self.isLiked = photoResult.likeByUser
        }
    }
    
    func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<PhotoResult, Error>) -> Void) {
        if self.busy == true {
            return
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        guard let defaultBaseURL = defaultBaseURL else {
            return
        }
        
        var components = URLComponents(url: defaultBaseURL, resolvingAgainstBaseURL: true)
        components?.path = "/photos"
        components?.queryItems = [
            URLQueryItem(name: "page", value: String(self.lastLoadedPage ?? 1)),
            URLQueryItem(name: "per_page", value: String(self.itemsPerPage))
        ]
        guard let url = components?.url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            defer {
                self.busy = false
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    self.lastLoadedPage = nextPage
                    
                    let decoder = JSONDecoder()
                    let photoResults = try decoder.decode([PhotoResult].self, from: data)
                    let photos = photoResults.map{Photo(photoResult: $0)}
                    self.photos += photos
                    
                    DispatchQueue.main.async {
                        print(self.photos.count)
                        
                        NotificationCenter.default.post(
                            name: ImagesListService.DidChangeNotification,
                            object: self,
                            userInfo: ["fetched": true]
                        )
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        self.busy = true
        task.resume()
    }
}

