//
//  TrendingGifsService.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation

enum TrendingGifsServiceError: Error {
    case loadFailure
}

protocol TrendingGifsServiceProtocol {
    func getGifs(offset: Int, completion: @escaping (Result<GifsModel, TrendingGifsServiceError>) -> Void)
}

extension TrendingGifsServiceProtocol {
    func getGifs(completion: @escaping (Result<GifsModel, TrendingGifsServiceError>) -> Void) {
        getGifs(offset: 0, completion: completion)
    }
}

final class TrendingGifsService: TrendingGifsServiceProtocol {
    private let service: RequestService
    private let dataStore: GifsInfoDataStoreProtocol
    private let key: String
    
    init(key: String, service: RequestService, dataStore: GifsInfoDataStoreProtocol) {
        self.service = service
        self.dataStore = dataStore
        self.key = key
    }
    
    func getGifs(offset: Int, completion: @escaping (Result<GifsModel, TrendingGifsServiceError>) -> Void) {
        service.request(LoadTrendingGifsEndpoint(apiKey: key, offset: offset)) { [weak self] result in
            if case .success(let newData) = result {
                self?.dataStore.addGifsInfo(from: newData)
            }
            
            completion(result.mapError { _ in TrendingGifsServiceError.loadFailure })
        }
    }
}
