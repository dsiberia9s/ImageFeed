//
//  ViewController.swift
//  ImageFeed
//
//  Created by Dmitrii on 03.07.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    let imagesListService = ImagesListService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var token: String?
    var photos: [ImagesListService.Photo] = []
    let notificationCenter = NotificationCenter.default
    var singleImageViewController: SingleImageViewController?
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        notificationCenter.addObserver(self, selector: #selector(self.handleNotification), name: imagesListService.DidChangeNotification, object: nil)
        
        self.token = oauth2TokenStorage.token
        
        if self.token != nil {
            self.imagesListService.fetchPhotosNextPage(self.token!) { _ in }
        }
    }
    
    deinit {
        notificationCenter.removeObserver(self, name: imagesListService.DidChangeNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            singleImageViewController = Optional(segue.destination as! SingleImageViewController)
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                singleImageViewController?.fullImageUrl = photos[selectedRow].largeImageURL
            }
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == imagesListService.photos.count {
            if self.token != nil {
                self.imagesListService.fetchPhotosNextPage(self.token!) { _ in }
            }
        }
    }
    
    @objc func handleNotification(_ notification: Notification) {
        print("🔔")
        self.updateTableViewAnimated()
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        if let imageListCell = cell as? ImagesListCell {
            configCell(for: imageListCell, with: indexPath)
            imageListCell.delegate = self
            return imageListCell
        } else {
            return cell
        }
    }
}

// MARK: - ImagesListViewController

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = self.photos[indexPath.row]
        let imageUrlString = photo.thumbImageURL
        let imageUrl = URL(string: imageUrlString ?? "")
        
        cell.cellImage.kf.indicatorType = .activity
        
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        // Создайте UIImageView для placeholder-изображения
        let placeholderImageView = UIImageView(image: UIImage(named: "stub"))
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.cellImage.addSubview(placeholderImageView)
        
        let placeholderWidthConstraint = NSLayoutConstraint(item: placeholderImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 83)
        let placeholderHeightConstraint = NSLayoutConstraint(item: placeholderImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 75)
        
        let centerXConstraint = NSLayoutConstraint(item: placeholderImageView, attribute: .centerX, relatedBy: .equal, toItem:  cell.cellImage, attribute: .centerX, multiplier: 1.0, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: placeholderImageView, attribute: .centerY, relatedBy: .equal, toItem:  cell.cellImage, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        cell.cellImage.addConstraints([placeholderWidthConstraint, placeholderHeightConstraint, centerXConstraint, centerYConstraint])
        
        cell.cellImage.kf.setImage(
            with: imageUrl,
            placeholder: nil,
            options: nil,
            completionHandler: { result in
                placeholderImageView.removeFromSuperview()
                cell.cellImage.kf.indicatorType = .none
                
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        )
        
        if let createdAt = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: createdAt)
        } else {
            cell.dateLabel.text = ""
        }
        
        let likeImage = photo.isLiked ? UIImage(named: "likeButtonTrue") : UIImage(named: "likeButtonFalse")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = self.photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / CGFloat(photo.size.width)
        let cellHeight = CGFloat(photo.size.height) * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        guard let token = self.token else {
            return
        }
        
        let photo = photos[indexPath.row]
        
        DispatchQueue.main.async {
            UIBlockingProgressHUD.show()
        }
        
        imagesListService.changeLike(token, photoId: photo.id, isLike: !photo.isLiked) {
            result in
            
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
            }
            
            switch result {
            case .success(()):
                DispatchQueue.main.async {
                    self.photos = self.imagesListService.photos
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                }
            case .failure(let error):
                self.showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(
            title: "Что-то пошло не так",
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
