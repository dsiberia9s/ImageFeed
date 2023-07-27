//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Dmitrii on 14.07.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @objc
    private func didTapButton() {
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
    
    private func createAvatarImage() {
        let profileImage = UIImage(systemName: "person.crop.circle.fill")
        let imageView = UIImageView(image: profileImage)
        
        imageView.tintColor = .gray
        
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.avatarImage = imageView
    }
    
    private func createLogoutButton() {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        
        button.tintColor = .red
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: self.avatarImage.centerYAnchor).isActive = true
        
        self.logoutButton = button
    }
    
    private func createUsernameLabel() {
        let label = UILabel()
        
        label.text = "Username"
        label.textColor = UIColor(named: "YP White")
        
        // Устанавливаем размер шрифта
        let fontSize: CGFloat = 23.0

        // Устанавливаем стиль шрифта "SF Pro" и его жирность (Weight700)
        let font = UIFont(name: "SFPro", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
        label.font = font

        // Устанавливаем межстрочный интервал (Line height) и свойство VariationWidth
        let lineHeight: CGFloat = 18.0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        // Применяем свойства межстрочного интервала и свойства VariationWidth к тексту в UILabel
        let attributedText = NSAttributedString(string: label.text ?? "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.attributedText = attributedText

        // Устанавливаем значение для межбуквенного интервала (Letter spacing)
        let letterSpacing: CGFloat = 0.3
        label.attributedText = NSAttributedString(string: label.text ?? "", attributes: [NSAttributedString.Key.kern: letterSpacing])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
        
        self.usernameLabel = label
    }
    
    private func createNicknameLabel() {
        let label = UILabel()
        
        label.text = "@nickname"
        label.textColor = UIColor(named: "YP Gray")
        
        // Устанавливаем размер шрифта
        let fontSize: CGFloat = 13.0

        let font = UIFont(name: "SFPro", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
        label.font = font

        // Устанавливаем межстрочный интервал (Line height) и свойство VariationWidth
        let lineHeight: CGFloat = 18.0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        // Применяем свойства межстрочного интервала и свойства VariationWidth к тексту в UILabel
        let attributedText = NSAttributedString(string: label.text ?? "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.attributedText = attributedText
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 136).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
        
        self.nicknameLabel = label
    }
    
    private func createDescriptionLabel() {
        let label = UILabel()
        
        label.text = "Description"
        label.textColor = UIColor(named: "YP White")
        
        label.numberOfLines = 0
        
        // Устанавливаем размер шрифта
        let fontSize: CGFloat = 13.0

        let font = UIFont(name: "SFPro", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
        label.font = font

        // Устанавливаем межстрочный интервал (Line height) и свойство VariationWidth
        let lineHeight: CGFloat = 18.0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        // Применяем свойства межстрочного интервала и свойства VariationWidth к тексту в UILabel
        let attributedText = NSAttributedString(string: label.text ?? "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.attributedText = attributedText
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
        
        self.descriptionLabel = label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAvatarImage()
        createLogoutButton()
        createUsernameLabel()
        createNicknameLabel()
        createDescriptionLabel()
    }
}
