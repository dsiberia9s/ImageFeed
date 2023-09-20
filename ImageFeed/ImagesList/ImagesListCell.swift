//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Dmitrii on 09.07.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: ImagesListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        likeButton.accessibilityIdentifier = "like button"
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(_  isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "likeButtonTrue") : UIImage(named: "likeButtonFalse")
        likeButton.setImage(likeImage, for: .normal)
        // likeButton.accessibilityIdentifier = isLiked ? "like button on" : "like button off"
        
    }
}
