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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.prepareForReuse()
        imageView.alpha = 0
    }
    
    func updateImage(data: Data) {
        imageView.animate(withGIFData: data)
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
}

