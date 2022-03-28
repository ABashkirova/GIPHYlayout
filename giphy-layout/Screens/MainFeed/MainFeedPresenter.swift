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
    func select(at indexPath: IndexPath)
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
    
    func select(at indexPath: IndexPath) {
        interactionInput?.routeToPreview(with: cellPresenters[indexPath.row].id)
    }
    
    private func loadGif(for presenter: GyphyImagePresenter) {
        gifLoader.load(url: presenter.url) { image in
            guard let image = image else {
                return
            }
            presenter.updateImage(image)
        }
    }
    
    private func loadNext() {
        guard canLoadNextBatch else { return }
        canLoadNextBatch = false
        
        loadFeedItems(offset: cellPresenters.count)
    }
    
    private func loadFeedItems(offset: Int = 0) {
        trendingGifLoader.getGifs(offset: offset) { [weak self] result in
            switch result {
            case .success(let model):
                self?.addNewGifs(gifs: model)
            case .failure(let error):
                self?.handleError(error)
            }
            self?.canLoadNextBatch = true
        }
    }
    
    private func addNewGifs(gifs: GifsModel) {
        let cellPresenters = cellPresenters + gifs.data.compactMap { $0.cellPresenter }
        interactionInput?.update(cellPresenters: cellPresenters)
        self.cellPresenters = cellPresenters
    }
    
    private func handleError(_ error: Error) {
        interactionInput?.showMessage(.failureLoading)
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
        return GyphyImagePresenter(id: id, url: url, feedItem: feedInfo)
    }
}
