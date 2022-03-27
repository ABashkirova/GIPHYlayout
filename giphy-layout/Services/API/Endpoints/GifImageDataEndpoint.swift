//
//  GifImageDataEndpoint.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation
import UIKit

enum GifImageDataError: Error {
    case notValid
}

struct GifImageDataEndpoint: Endpoint, RequestBuildable {
    typealias Response = Data
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func makeRequest() -> URLRequest? {
        get(url)
    }
    
    func response(from response: URLResponse?, with body: Data) throws -> Response {
        return body
    }
}
