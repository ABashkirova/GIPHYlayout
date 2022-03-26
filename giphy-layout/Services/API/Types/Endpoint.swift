//
//  Endpoint.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation


protocol Endpoint {
    associatedtype Response
    
    func makeRequest() -> URLRequest?
    
    func response(from response: URLResponse?, with body: Data) throws -> Response
    
    func validate(request: URLRequest?, response: HTTPURLResponse, data: Data?) throws
}

extension Endpoint {
    func validate(request: URLRequest?, response: HTTPURLResponse, data: Data?) throws {
        try ResponseValidator.validate(response, with: data)
    }
}

protocol JsonEndpoint: Endpoint where Response: Decodable { }

enum ResponseError: Error {
    case failureLoad(code: Int)
}
enum JsonResponseError: Error {
    case badParsing(error: Error)
}

extension JsonEndpoint {
    func validate(request: URLRequest?, response: HTTPURLResponse, data: Data?) throws {
        try ResponseValidator.validate(response, with: data)
    }
    
    func response(from response: URLResponse?, with body: Data) throws -> Response {
        return try JSONDecoder.default.decode(Response.self, from: body)
    }
}

enum ResponseValidator {
    static func validate(_ response: URLResponse?, with body: Data?) throws {
        try validateHTTPStatus(response)
    }

    // MARK: - Private Methods

    private static func validateHTTPStatus(_ response: URLResponse?) throws {
        guard
            let httpResponse = response as? HTTPURLResponse,
            !(200..<300).contains(httpResponse.statusCode)
        else { return }
        throw ResponseError.failureLoad(code: httpResponse.statusCode)
    }
}
