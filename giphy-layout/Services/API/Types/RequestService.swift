//
//  RequestService.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation
import UIKit

protocol RequestService: AnyObject {
    func request<T>(
        _ endpoint: T,
        completionHandler: @escaping (Result<T.Response, Error>) -> Void
    ) where T: Endpoint
}

final class RequestServiceURLSession {
    private let session: URLSession = URLSession(configuration: .default)
    private let completionQueue: DispatchQueue = .main
}

extension RequestServiceURLSession: RequestService {
    func request<T>(
        _ endpoint: T,
        completionHandler: @escaping (Result<T.Response, Error>) -> Void
    ) where T: Endpoint {
        guard let urlRequest: URLRequest = endpoint.makeRequest() else {
            return
        }
        let task = session.dataTask(with: urlRequest) { data, response, error in
            let result = Result<T.Response, Error> (catching: { () throws -> T.Response in
                if let httpResponse = response as? HTTPURLResponse {
                    try endpoint.validate(request: urlRequest, response: httpResponse, data: data)
                }
                let data = data ?? Data()
                if let error = error {
                    throw error
                }
                return try endpoint.response(from: response, with: data)
            })
            self.completionQueue.async {
                completionHandler(result)
            }
        }
        task.resume()
    }
}
