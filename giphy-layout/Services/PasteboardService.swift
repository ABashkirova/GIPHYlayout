//
//  PasteboardService.swift
//  GyphyLayout
//
//  Created by Alexandra Bashkirova on 28.03.2022.
//

import UIKit
import Photos

protocol PasteboardServiceProtocol {
    func setLink(link: URL)
    func setGif(data: Data)
}

final class PasteboardService: PasteboardServiceProtocol {
    let pasteboard = UIPasteboard.general
    
    func setLink(link: URL) {
        pasteboard.url = link
    }
    
    func setGif(data: Data) {
        pasteboard.setData(data, forPasteboardType: UTType.gif.identifier)
    }
}
