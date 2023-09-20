//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Dmitrii on 20.09.2023.
//

import Foundation

public protocol ImageListPresenterProtocol {
    var delegate: ImagesListViewController? { get set }
    var photos: [ImagesListService.Photo] { get set }
    var imagesListService: ImagesListService { get set }
    var dateFormatter: DateFormatter { get set }
    func viewDidLoad()
    func nextPage(row: Int)
    func didTapLike(at indexPath: IndexPath, completition: @escaping (Bool, Error?) -> Void)
    func isPhotoLiked(at indexPath: IndexPath) -> Bool
}

final class ImageListPresenter: ImageListPresenterProtocol {
    weak var delegate: ImagesListViewController?
    private let oauth2TokenStorage = OAuth2TokenStorage()
    var imagesListService = ImagesListService.shared
    private let notificationCenter = NotificationCenter.default
    var photos: [ImagesListService.Photo] = []
    private var token: String?
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func viewDidLoad() {
        self.token = oauth2TokenStorage.token
        
        if self.token != nil {
            self.imagesListService.fetchPhotosNextPage(self.token!) { _ in }
        }
        
        notificationCenter.addObserver(self, selector: #selector(self.handleNotification), name: imagesListService.DidChangeNotification, object: nil)
    }
    
    func nextPage(row: Int) {
        if row + 1 == imagesListService.photos.count {
            if token != nil {
                imagesListService.fetchPhotosNextPage(token!) { _ in }
            }
        }
    }
    
    @objc
    func handleNotification(_ notification: Notification) {
        print("🔔")
        self.delegate?.updateTableViewAnimated()
    }
    
    func isPhotoLiked(at indexPath: IndexPath) -> Bool {
        return photos[indexPath.row].isLiked
    }
    
    func didTapLike(at indexPath: IndexPath, completition: @escaping (Bool, Error?) -> Void) {
        guard let token = self.token else {
            completition(false, nil)
            return
        }
        
        let photo = photos[indexPath.row]
        
        imagesListService.changeLike(token, photoId: photo.id, isLike: !photo.isLiked) {
            result in
            
            switch result {
            case .success(()):
                self.photos = self.imagesListService.photos
                DispatchQueue.main.async {
                    completition(true, nil)
                }
            case .failure(let error):
                completition(false, error)
            }
        }
    }
}
