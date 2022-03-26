//
//  JsonCodable.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation

extension JSONDecoder {
    static let `default`: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

extension JSONEncoder {
    static let `default`: JSONEncoder = {
        let encoder = JSONEncoder()
        var formatting: JSONEncoder.OutputFormatting = .prettyPrinted
        encoder.outputFormatting = formatting
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
}
