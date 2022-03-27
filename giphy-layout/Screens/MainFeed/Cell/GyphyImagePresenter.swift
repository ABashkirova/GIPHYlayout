//
//  GyphyImagePresenter.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation
import UIKit

class GyphyImagePresenter: CellPresenter {
    let reusableCellClass: Reusable.Type = GyphyViewCell.self
    let id: String
    let url: URL
    let feedItem: FeedItemModel
    private(set) weak var view: GyphyViewCell?
    var isOneTimeDisplayed = false
    
    init(id: String, url: URL, feedItem: FeedItemModel) {
        self.id = id
        self.url = url
        self.feedItem = feedItem
    }
    
    func updateImage(_ image: Data) {
        reloadImage(image)
        willDisplay()
    }
    
    func setView(view: GyphyViewCell) {
        guard self.view !== view else {
            return
        }
        self.view = view
    }
    
    func willDisplay() {
        view?.startAnimation()
    }
    
    func didEndDisplaying() {
        view?.endAnimating()
    }
    
    private func reloadImage(_ image: Data) {
        view?.updateImage(data: image)
    }
}
