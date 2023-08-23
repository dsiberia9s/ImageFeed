//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Dmitrii on 08.08.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    // private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    internal let oauth2Service = OAuth2Service()
    internal let oauth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        if let token = OAuth2TokenStorage().token {
            fetchProfile(token: token)
            
            if let username = profileService.profile?.username {
                ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in }
            }
        } else {
            // Заметка на будущее: как найти viewcontroller в storyboard
            if let authViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController {
                print("AuthViewController found!")
                
                authViewController.delegate = self
                authViewController.modalPresentationStyle = .fullScreen
                self.present(authViewController, animated: true, completion: nil)
            } else {
                print("AuthViewController not found.")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

/*
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
*/

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        print("Authentication successful with code: \(code)")

        self.fetchAuthToken(code)
    }

    private func fetchAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                self.showErrorAlert(message: "Не удалось войти в систему")
                // Этот алерт не всплывает.
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
    
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure:
                self.showErrorAlert(message: "Не удалось получить профиль")
                // Алерт всплывает, но затем чёрный экран.
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


