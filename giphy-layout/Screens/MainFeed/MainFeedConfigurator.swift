//
//  MainFeedConfigurator.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation
import UIKit

struct MainFeedConfigurator {
    private let trendingGifLoader: TrendingGifsServiceProtocol
    private let gifLoader: ImageLoaderProtocol
    
    init(trendingGifLoader: TrendingGifsServiceProtocol, gifLoader: ImageLoaderProtocol) {
        self.trendingGifLoader = trendingGifLoader
        self.gifLoader = gifLoader
    }
    
    func configure() -> UIViewController {
        let presenter = MainFeedPresenter(trendingGifLoader: trendingGifLoader, gifLoader: gifLoader)
        let vc = MainFeedViewController(presenter: presenter)
        let dataSource = MainFeedViewDataSource()
        vc.dataSource = dataSource
        presenter.setInteractionInput(vc)
        return vc
    }
    
}
