//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Dmitrii on 28.08.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImagesListService.shared
        let oauth2TokenStorage = OAuth2TokenStorage()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: service.DidChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        let token = oauth2TokenStorage.token
        service.fetchPhotosNextPage(token!) { _ in }
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}
