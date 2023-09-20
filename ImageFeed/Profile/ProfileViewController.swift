//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Dmitrii on 14.07.2023.
//

import UIKit
import Kingfisher

protocol ProfileControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
}

final class ProfileViewController: UIViewController, ProfileControllerProtocol, ProfileViewControllerDelegate {
    var presenter: ProfilePresenterProtocol?
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    @objc func didTapLogout() {
        logoutUser()
    }
    
    private func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(didTapLogout)
        )
        button.tintColor = UIColor(named: "YP Red")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "logout button"
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name Lastname"
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
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "@username"
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
    
    let descriptionLabel: UILabel = {
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
    
    func updateProfileDetails(name: String, loginName: String, bio: String) {
        self.usernameLabel.text = name
        self.nicknameLabel.text = loginName
        self.descriptionLabel.text = bio
    }
    
    func updateAvatar() {
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
    
    func logoutUser() {        
        let alertController = UIAlertController(
            title: "Bye bye!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
                
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.presenter?.logout()
            
            for view in self.view.subviews {
                if view is UILabel {
                    view.removeFromSuperview()

                    guard let window = UIApplication.shared.windows.first else
                    {
                      fatalError("Invalid Configuration")
                    }

                    let tabBarController = UIStoryboard(
                        name: "Main",
                        bundle: .main
                    ).instantiateViewController(
                            withIdentifier: "AuthViewController"
                    )
                    
                    window.rootViewController = tabBarController
                }
            }
            
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
