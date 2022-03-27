//
//  FeedItemModel.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation

struct FeedItemModel {
    let ratio: Double
    
    init(height: Int, width: Int) {
        ratio = Double(height) / Double(width)
    }
}
