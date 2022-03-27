//
//  GifPreviewMessage.swift
//  GyphyLayout
//
//  Created by Alexandra Bashkirova on 28.03.2022.
//

import Foundation

enum GifPreviewMessage {
    case savedToCameraRoll
    case failedSaveToCameraRoll
    case openSettings
    case errorLoading
    case copied
}

extension GifPreviewMessage {
    var title: String {
        switch self {
        case .savedToCameraRoll:
            return "💚 saved"
        case .failedSaveToCameraRoll:
            return "⚠️ not saved"
        case .openSettings:
            return "Go to settings"
        case .errorLoading:
            return "❌ bad loading"
        case .copied:
            return "💚 copied"
        }
    }
}
