//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Dmitrii on 23.08.2023.
//

import UIKit
 
final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        
        let imageListViewPresenter = ImageListPresenter()
        imagesListViewController.configure(imageListViewPresenter)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        let profilePresenter = ProfilePresenter()
        profileViewController.configure(profilePresenter)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
