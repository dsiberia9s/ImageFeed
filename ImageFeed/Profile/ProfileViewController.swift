//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Dmitrii on 14.07.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    @objc
    private func didTapButton() {
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
                
                oauth2TokenStorage.token = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let token = oauth2TokenStorage.token else {
            return
        }
        
        guard let profile = self.profileService.profile else {
            return
        }
        
        setupViews()
        setupConstraints()
        setupObservers()
        updateProfileDetails(profile)
        updateAvatar()
    }
    
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: ProfileViewController.self,
            action: #selector(didTapButton)
        )
        button.tintColor = UIColor(named: "YP Red")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YP White")
        let fontSize: CGFloat = 23.0
        let font = UIFont(name: "SFPro", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
        label.font = font

        let lineHeight: CGFloat = 18.0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let letterSpacing: CGFloat = 0.3

        label.attributedText = NSAttributedString(
            string: "",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .kern: letterSpacing
                        ]
        )

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "@nickname"
        label.textColor = UIColor(named: "YP Gray")
        let fontSize: CGFloat = 13.0
        let font = UIFont(name: "SFPro", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
        label.font = font

        let lineHeight: CGFloat = 18.0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let letterSpacing: CGFloat = 0.3

        label.attributedText = NSAttributedString(
            string: "",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .kern: letterSpacing
                        ]
        )

        label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = UIColor(named: "YP White")
        label.numberOfLines = 0
        let fontSize: CGFloat = 13.0
        let font = UIFont(name: "SFPro", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
        label.font = font

        let lineHeight: CGFloat = 18.0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let letterSpacing: CGFloat = 0.3

        label.attributedText = NSAttributedString(
            string: "",
            attributes: [
                .paragraphStyle: paragraphStyle,
                .kern: letterSpacing
                        ]
        )

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Private Methods
        
    private func setupViews() {
        view.addSubview(avatarImage)
        view.addSubview(logoutButton)
        view.addSubview(usernameLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(descriptionLabel)
        
        self.view.backgroundColor = UIColor(named: "YP Black")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Avatar image constraints
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            
            // Logout button constraints
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            
            // Username label constraints
            usernameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
            usernameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            
            // Nickname label constraints
            nicknameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nicknameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 136),
            nicknameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            
            // Description label constraints
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func setupObservers() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
    }
    
    private func updateProfileDetails(_ profile: ProfileService.Profile) {
        self.usernameLabel.text = profile.name
        self.nicknameLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL) else { return }
        
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)

        self.avatarImage.kf.indicatorType = .activity
        self.avatarImage.kf.setImage(
            with: imageUrl,
            options: [
                .processor(processor)
            ]
        ) { result in
            switch result {
            case .success(let value):
                print(value.image)
                print(value.cacheType)
                print(value.source)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
