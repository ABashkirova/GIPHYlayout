//
//  RequestBuildable.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation

protocol RequestBuildable {
    func get(_ url: URL, query: [URLQueryItem]?) -> URLRequest
}

extension RequestBuildable {
    func get(_ url: URL, query: [URLQueryItem]? = nil) -> URLRequest {
        guard let queryItems = query else {
            return URLRequest(url: url)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        
        guard let queryUrl = components?.url else {
            return URLRequest(url: url)
        }
        
        return URLRequest(url: queryUrl)
    }
}
