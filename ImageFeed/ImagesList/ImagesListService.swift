//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Dmitrii on 27.08.2023.
//

import Foundation

final public class ImagesListService {
    private init() { }
    static public let shared = ImagesListService()
    private let itemsPerPage: Int = 10
    var photos: [Photo] = []
    private var lastLoadedPage: Int?
    let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    var busy: Bool = false
    let dateFormatter = ISO8601DateFormatter()
    
    public struct Photo: Codable {
        let id: String
        let size: CGSize
        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: String?
        let largeImageURL: String?
        var isLiked: Bool
        
        init(photoResult: PhotoResult) {
            self.id = photoResult.id
            self.size = CGSize(width: photoResult.width, height: photoResult.height)
            self.createdAt = photoResult.createdAt
            self.welcomeDescription = photoResult.description
            self.thumbImageURL = photoResult.urls.thumb?.absoluteString
            self.largeImageURL = photoResult.urls.full?.absoluteString
            self.isLiked = photoResult.likedByUser
        }
    }
    
    func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<PhotoResult, Error>) -> Void) {
        if self.busy == true {
            return
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        var components = URLComponents(url: defaultBaseURL, resolvingAgainstBaseURL: true)
        components?.path = "/photos"
        components?.queryItems = [
            URLQueryItem(name: "page", value: String(nextPage)),
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
                /*
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON String: \(jsonString)")
                }
                */
                
                do {
                    self.lastLoadedPage = nextPage
                    
                    let decoder = JSONDecoder()
                    let photoResults = try decoder.decode([PhotoResult].self, from: data)
                    let photos = photoResults.map{Photo(photoResult: $0)}
                    self.photos += photos
                    
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(
                            name: self.DidChangeNotification,
                            object: self,
                            userInfo: nil
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
    
    func changeLike(_ token: String, photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let url = defaultBaseURL.appendingPathComponent("/photos/\(photoId)/like")
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Response.self, from: data)
                    let photo = response.photo
                    let isLike = photo.likedByUser
                    
                    if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
                        self.photos[index].isLiked = isLike
                    }
                    
                    completion(.success(()))
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
}

