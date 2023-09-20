//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Dmitrii on 19.09.2023.
//

import Foundation

public protocol ProfileViewControllerDelegate: AnyObject {
    func updateAvatar()
    func updateProfileDetails(name: String, loginName: String, bio: String)
}

public protocol ProfilePresenterProtocol {
    var delegate: ProfileViewControllerDelegate? { get set }
    func viewDidLoad()
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var delegate: ProfileViewControllerDelegate?
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var oauth2TokenService = OAuth2Service.shared
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        guard oauth2TokenStorage.token != nil else {
            return
        }
        
        guard profileService.profile != nil else {
            return
        }
        
        setupObservers()
        updateProfileDetails()
        delegate?.updateAvatar()
    }
    
    func logout() {
        oauth2TokenService.clean()
    }
    
    private func setupObservers() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.updateAvatar()
        }
    }
    
    private func updateProfileDetails() {
        let profile = profileService.profile!
        
        delegate?.updateProfileDetails(
            name: profile.name,
            loginName: profile.loginName,
            bio: profile.bio
        )
    }
}

