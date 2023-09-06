//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Dmitrii on 16.07.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var fullImageUrl: String? = nil
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }

        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    
    private func loadImage() {
        if let fullImageUrlString = fullImageUrl,
           let fullImageUrl = URL(string: fullImageUrlString) {
            
            UIBlockingProgressHUD.show()
            
            imageView.kf.setImage(with: fullImageUrl) {
                [weak self] result in
                guard let self = self else { return }
                
                UIBlockingProgressHUD.dismiss()
                
                switch result {
                case .success(let imageResult):
                    self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                    scrollView.minimumZoomScale = 0.1
                    scrollView.maximumZoomScale = 1.25
                case .failure:
                    showError()
                }
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showError() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так.",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Не надо", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

        let retryAction = UIAlertAction(title: "Повторить", style: .default) {
            [weak self] _ in
            self?.loadImage()
        }
        alertController.addAction(retryAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
