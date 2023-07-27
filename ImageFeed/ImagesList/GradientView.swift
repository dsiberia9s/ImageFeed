//
//  GradientView.swift
//  ImageFeed
//
//  Created by Dmitrii on 10.07.2023.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateGradient()
    }
    
    private func updateGradient() {
        guard let gradientLayer = layer as? CAGradientLayer else { return }

        gradientLayer.colors = [
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor,
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.2).cgColor,
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.2).cgColor,
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor
        ]
        
        gradientLayer.locations = [0, NSNumber(value: 0.5), NSNumber(value: 0.5), 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }


}
