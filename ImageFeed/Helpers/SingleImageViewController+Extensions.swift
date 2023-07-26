//
//  SingleImageViewController+Extensions.swift
//  ImageFeed
//
//  Created by Dmitrii on 17.07.2023.
//

import UIKit

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
