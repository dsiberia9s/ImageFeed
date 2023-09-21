//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Dmitrii on 19.09.2023.
//

import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var delegate: ImageFeed.ProfileViewControllerDelegate?

    var viewDidLoadCalled: Bool = false
    var logoutCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        updateProfileDetails()
    }
    
    func logout() {
        logoutCalled = true
    }
    
    func updateProfileDetails() {
        delegate?.updateProfileDetails(
            name: "TestName",
            loginName: "TestLoginName",
            bio: "TestBio"
        )
    }
}
