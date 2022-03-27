//
//  GyphyViewCell.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import UIKit
import Gifu

class GyphyViewCell: CollectionViewCell<GyphyImagePresenter>, NibReusable {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var imageView: GIFImageView!
    
    override func didSetup() {
        guard let presenter = presenter else {
            return
        }
        presenter.setView(view: self)
        startLoadingAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.prepareForReuse()
        imageView.alpha = 0
    }
    
    func updateImage(data: Data) {
        imageView.animate(withGIFData: data)
        cleanLoadingAnimation()
    }
    
    func startAnimation() {
        guard let alreadyDisplayed = presenter?.isOneTimeDisplayed else {
            imageView.alpha = 1
            return
        }
        let duration = alreadyDisplayed ? 0.05 : 0.15
        UIView.animate(withDuration: duration, delay: 0, options: [.showHideTransitionViews]) {
            self.imageView.alpha = 1
        } completion: { _ in }
    }
    
    func endAnimating() {
        imageView.stopAnimatingGIF()
        presenter?.isOneTimeDisplayed = true
    }
    
    private func startLoadingAnimating() {
        cleanLoadingAnimation()
        let gradientLayer = addGradientLayer()
        colorView.layer.addSublayer(gradientLayer)
        let animation = addAnimation()
        gradientLayer.add(animation, forKey: animation.keyPath)
    }
    
    private func cleanLoadingAnimation() {
        colorView.layer.sublayers?.forEach { layer in
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
    }
    
    private func addAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.8
        return animation
    }
    
    private func addGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = colorView.frame
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0),
            UIColor.white.withAlphaComponent(0.6),
            UIColor.white.withAlphaComponent(0)
        ].map { $0.cgColor }
        gradientLayer.locations = [0.0, 0.5, 1.0]
        return gradientLayer
    }
}

