//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Dmitrii on 28.08.2023.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        // given
        let viewController = WebViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        // given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        // given
        let authHelper = AuthHelper() //Dummy
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress) // return value verification
        
        // then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        // given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        // when
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        // then
        XCTAssertTrue(urlString.contains(configuration.AuthURLString))
        XCTAssertTrue(urlString.contains(configuration.AccessKey))
        XCTAssertTrue(urlString.contains(configuration.RedirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.AccessScope))
    }
    
    func testCodeFromURL() {
        // given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        // when
        let code = authHelper.code(from: url)
        
        // then
        XCTAssertEqual(code, "test code")
    }
    
    func testConfigureWithProfilePresenter() {
        // given
        let view = ProfileViewController()
        let presenter = ProfilePresenter()
        
        // when
        view.configure(presenter)
        
        // then
        XCTAssertNotNil(view.presenter)
    }
    
    func testProfilePresenterCalls() {
        // given
        let view = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()
        
        // when
        view.configure(presenterSpy)
        view.viewDidLoad()

        // then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testUpdateProfileDetails() {
        // given
        let profileViewController = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()
        
        // when
        profileViewController.configure(presenterSpy)
        profileViewController.viewDidLoad()
        
        // then
        XCTAssertEqual(profileViewController.usernameLabel.text, "TestName", "Username label text should be 'TestName'")
        XCTAssertEqual(profileViewController.nicknameLabel.text, "TestLoginName", "Nickname label text should be 'TestLoginName'")
        XCTAssertEqual(profileViewController.descriptionLabel.text, "TestBio", "Description label text should be 'TestBio'")
    }
    
    func testLogoutButton() {
        // given
        let profileViewController = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()
        
        // when
        profileViewController.configure(presenterSpy)
        profileViewController.presenter?.logout()
        
        // then
        XCTAssertTrue(presenterSpy.logoutCalled)
    }
    
    func testConfigureWithImageListPresenter() {
        // given
        let view = ImagesListViewController()
        let presenter = ImageListPresenter()
        
        // when
        view.configure(presenter)
        
        // then
        XCTAssertNotNil(view.presenter)
    }
    
    func testImageListPresenterCalls() {
        // given
        let view = ImagesListViewController()
        let presenterSpy = ImageListPresenterSpy()
        
        // when
        view.configure(presenterSpy)
        view.viewDidLoad()

        // then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    
}

/*
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
*/
