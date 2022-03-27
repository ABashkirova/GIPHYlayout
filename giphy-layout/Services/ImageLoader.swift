//
//  ImageLoader.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation
import UIKit

protocol ImageLoaderProtocol: AnyObject {
    func load(url: URL, item: GyphyImagePresenter, completion: @escaping (GyphyImagePresenter, Data?) -> Void)
}

class ImageLoader: ImageLoaderProtocol {
    private let service: RequestServiceURLSession
    
    private let cachedImages = NSCache<NSURL, NSData>()
    
    private var loadingResponses = [NSURL: [(GyphyImagePresenter, Data?) -> Void]]()
    
    init(service: RequestServiceURLSession) {
        self.service = service
        cachedImages.totalCostLimit = 100_000_000
    }
    
    func load(url: URL, item: GyphyImagePresenter, completion: @escaping (GyphyImagePresenter, Data?) -> Void) {
        guard let nsUrl = NSURL(string: url.absoluteString) else {
            completion(item, nil)
            return
        }
        if let cachedImage = data(url: nsUrl) {
            completion(item, Data(referencing: cachedImage))
            return
        }
    
        guard loadingResponses[nsUrl] == nil else {
            loadingResponses[nsUrl]?.append(completion)
            return
        }
        loadingResponses[nsUrl] = [completion]
        
        service.request(GifImageDataEndpoint(url: url)) { [weak self] result in
            guard case .success(let data) = result, let listeners = self?.loadingResponses[nsUrl] else {
                completion(item, nil)
                return
            }
            self?.cachedImages.setObject(NSData(data: data), forKey: nsUrl, cost: data.count)
            listeners.forEach { completion in
                completion(item, data)
            }
            self?.loadingResponses[nsUrl] = nil
        }
    }
    
    private func data(url: NSURL) -> NSData? {
        cachedImages.object(forKey: url)
    }
}
