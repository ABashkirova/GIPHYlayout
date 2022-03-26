//
//  LoadTrendingGifsEndpoint.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation

struct LoadTrendingGifsEndpoint: JsonEndpoint, RequestBuildable {
    typealias Response = GifsModel
    
    private let url = "https://api.giphy.com/v1/gifs/trending"
    private let apiKey: String
    private let offset: Int?
    
    init(apiKey: String, offset: Int?) {
        self.apiKey = apiKey
        self.offset = offset
    }
    
    func makeRequest() -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var params: [URLQueryItem] = [URLQueryItem(name: "api_key", value: apiKey)]
        if let offset = offset {
            params.append(URLQueryItem(name: "offset", value: "\(offset)"))
        }
        return get(url, query: params)
    }
}
