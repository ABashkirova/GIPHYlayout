//
//  FeedMessage.swift
//  GyphyLayout
//
//  Created by Alexandra Bashkirova on 28.03.2022.
//

import Foundation

enum FeedMessage {
    case failureLoading
}

extension FeedMessage {
    var title: String {
        switch self {
        case .failureLoading:
            return "❌ bad loading"
        }
    }
}
