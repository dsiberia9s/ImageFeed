//
//  ImagesListViewController+Extensions.swift
//  ImageFeed
//
//  Created by Dmitrii on 09.07.2023.
//

import UIKit

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: self.photosName[indexPath.row]) else {
            print("Image not found")
            
            return
        }
        
        cell.cellImage.image = image
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "likeTrueButton") : UIImage(named: "likeFalseButton")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}
