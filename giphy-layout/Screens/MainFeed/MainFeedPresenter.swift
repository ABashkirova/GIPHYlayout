//
//  MainFeedPresenter.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation

protocol MainFeedPresentationOutput {
    func moduleDidLoad()
    func willDisplay(at indexPath: IndexPath)
    func endDisplaying(at indexPath: IndexPath)
}

final class MainFeedPresenter: MainFeedPresentationOutput {
    private let trendingGifLoader: TrendingGifsServiceProtocol
    private let gifLoader: ImageLoaderProtocol
    
    private weak var interactionInput: MainFeedInteractionInput?
    
    private var cellPresenters: [GyphyImagePresenter] = []
    private var canLoadNextBatch: Bool = false
    private let minimumDistanceToEndOfListForLoadNew = 12
    private let batchSize = 50
    
    init(trendingGifLoader: TrendingGifsServiceProtocol, gifLoader: ImageLoaderProtocol) {
        self.trendingGifLoader = trendingGifLoader
        self.gifLoader = gifLoader
    }
    
    func setInteractionInput(_ interactionInput: MainFeedInteractionInput) {
        self.interactionInput = interactionInput
    }
    
    func moduleDidLoad() {
        loadFeedItems()
    }
    
    func willDisplay(at indexPath: IndexPath) {
        let presenter = cellPresenters[indexPath.row]
        loadGif(for: presenter)
        
        if indexPath.row >= cellPresenters.count - minimumDistanceToEndOfListForLoadNew {
            loadNext()
        }
    }
    
    func endDisplaying(at indexPath: IndexPath) {
        cellPresenters[indexPath.row].didEndDisplaying()
    }
    
    func loadGif(for presenter: GyphyImagePresenter) {
        gifLoader.load(url: presenter.url, item: presenter) { item, image in
            guard let image = image else {
                return
            }
            presenter.updateImage(image)
        }
    }
    
    private func loadNext() {
        guard canLoadNextBatch else { return }
        canLoadNextBatch = false
        
        trendingGifLoader.getGifs(offset: cellPresenters.count) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.addNewGifs(gifs: model)
            case .failure:
                self.handleError()
            }
            self.canLoadNextBatch = true
        }
    }
    
    private func loadFeedItems() {
        trendingGifLoader.getGifs { [weak self] result in
            switch result {
            case .success(let model):
                self?.setup(gifs: model)
            case .failure:
                self?.handleError()
            }
            self?.canLoadNextBatch = true
        }
    }
    
    private func setup(gifs: GifsModel) {
        let cellPresenters = gifs.data.compactMap { $0.cellPresenter }
        interactionInput?.update(cellPresenters: cellPresenters)
        self.cellPresenters = cellPresenters
    }
    
    private func addNewGifs(gifs: GifsModel) {
        let cellPresenters = cellPresenters + gifs.data.compactMap { $0.cellPresenter }
        interactionInput?.update(cellPresenters: cellPresenters)
        self.cellPresenters = cellPresenters
    }
    
    private func handleError() {
        
    }
}

private extension GiphyDataInfo {
    var cellPresenter: GyphyImagePresenter? {
        guard let width = Int(images.fixedWidth.width),
              let height = Int(images.fixedWidth.height),
              let url = URL(string: images.fixedWidth.url)
        else {
            return nil
        }
        let feedInfo = FeedItemModel(height: height, width: width)
        return GyphyImagePresenter(url: url, feedItem: feedInfo)
    }
}
