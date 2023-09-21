//
//  ImageListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Dmitrii on 20.09.2023.
//

import ImageFeed
import Foundation

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    var delegate: ImageFeed.ImagesListViewController?
    var photos: [ImagesListService.Photo] = []
    var imagesListService = ImagesListService.shared
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var viewDidLoadCalled: Bool = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func nextPage(row: Int) {

    }

    func didTapLike(at indexPath: IndexPath, completition: @escaping (Bool, Error?) -> Void) {
        
    }

    func isPhotoLiked(at indexPath: IndexPath) -> Bool {
        return false
    }
}
