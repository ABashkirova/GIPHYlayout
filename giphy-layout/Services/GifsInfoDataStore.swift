//
//  GifsInfoDataStore.swift
//  GyphyLayout
//
//  Created by Alexandra Bashkirova on 27.03.2022.
//

import Foundation

protocol GifsInfoDataStoreProtocol: AnyObject {
    func preview(for id: String) -> GifPreviewPresentationModel?
    func addGifsInfo(from model: GifsModel)
}

final class GifsInfoDataStore: GifsInfoDataStoreProtocol {
    private var previewInfo: [String: GiphyImageInfo] = [:]
    
    func addGifsInfo(from model: GifsModel) {
        model.data.forEach {
            previewInfo[$0.id] = $0.images.downsized
        }
    }
    
    func preview(for id: String) -> GifPreviewPresentationModel? {
        guard let info = previewInfo[id] else { return nil }
        return GifPreviewPresentationModel(url: info.url)
    }
}
