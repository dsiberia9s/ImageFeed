//
//  ViewController.swift
//  ImageFeed
//
//  Created by Dmitrii on 03.07.2023.
//

import UIKit
import Kingfisher

protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
}

final public class ImagesListViewController: UIViewController, ImageListViewControllerProtocol {
    var presenter: ImageListPresenterProtocol?
    var singleImageViewController: SingleImageViewController?
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    @IBOutlet var tableView: UITableView!

    func configure(_ presenter: ImageListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.delegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if tableView != nil {
            tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        }
        
        presenter?.viewDidLoad()
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            singleImageViewController = Optional(segue.destination as! SingleImageViewController)
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                singleImageViewController?.fullImageUrl = presenter?.photos[selectedRow].largeImageURL
            }
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        presenter?.nextPage(row: indexPath.row)
    }
    
    func updateTableViewAnimated() {
        guard var presenter = presenter else { return }

        let oldCount = presenter.photos.count
        let newCount = presenter.imagesListService.photos.count

        presenter.photos = presenter.imagesListService.photos
        
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
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        guard
            let photo = presenter?.photos[indexPath.row],
            let imageUrlString = photo.thumbImageURL,
            let imageUrl = URL(string: imageUrlString ) else {
            return
        }
        
        cell.cellImage.kf.indicatorType = .activity
        
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        // Создайте UIImageView для placeholder-изображения
        let placeholderImageView = UIImageView(image: UIImage(named: "stub"))
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.cellImage.addSubview(placeholderImageView)
        
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false

        placeholderImageView.widthAnchor.constraint(equalToConstant: 83).isActive = true
        placeholderImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        placeholderImageView.centerXAnchor.constraint(equalTo: cell.cellImage.centerXAnchor).isActive = true
        placeholderImageView.centerYAnchor.constraint(equalTo: cell.cellImage.centerYAnchor).isActive = true
        
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
            cell.dateLabel.text = presenter?.dateFormatter.string(from: createdAt)
        } else {
            cell.dateLabel.text = ""
        }
        
        let likeImage = photo.isLiked ? UIImage(named: "likeButtonTrue") : UIImage(named: "likeButtonFalse")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photos[indexPath.row] else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / CGFloat(photo.size.width)
        let cellHeight = CGFloat(photo.size.height) * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return
        }
        
        DispatchQueue.main.async {
            UIBlockingProgressHUD.show()
        }
        
        presenter?.didTapLike(at: indexPath) {
            [weak self] success, error in
            
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
            }
            
            if success {
                cell.setIsLiked(self?.presenter?.isPhotoLiked(at: indexPath) ?? false)
            } else if let error = error {
                self?.showErrorAlert(message: error.localizedDescription)
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
