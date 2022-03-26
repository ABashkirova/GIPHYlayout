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
    func getGifs(completion: @escaping  (Result<GifsModel, TrendingGifsServiceError>) -> Void)
}

final class TrendingGifsService: TrendingGifsServiceProtocol {
    private let service: RequestService
    
    init(service: RequestService) {
        self.service = service
    }
    
    func getGifs(completion: @escaping (Result<GifsModel, TrendingGifsServiceError>) -> Void) {
        service.request(LoadTrendingGifsEndpoint(apiKey: "2DvJJTjzG77VFsRxeGpLqjeLWPX2B5Dy", offset: 0)) { result in
            completion(result.mapError { _ in TrendingGifsServiceError.loadFailure })
        }
    }
}
