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
    func getGifs(offset: Int, completion: @escaping  (Result<GifsModel, TrendingGifsServiceError>) -> Void)
}

extension TrendingGifsServiceProtocol {
    func getGifs(completion: @escaping  (Result<GifsModel, TrendingGifsServiceError>) -> Void) {
        getGifs(offset: 0, completion: completion)
    }
}

final class TrendingGifsService: TrendingGifsServiceProtocol {
    private let service: RequestService
    private let key: String
    
    init(key: String, service: RequestService) {
        self.service = service
        self.key = key
    }
    
    func getGifs(offset: Int, completion: @escaping (Result<GifsModel, TrendingGifsServiceError>) -> Void) {
        service.request(LoadTrendingGifsEndpoint(apiKey: key, offset: offset)) { result in
            completion(result.mapError { _ in TrendingGifsServiceError.loadFailure })
        }
    }
}
