//
//  GifsModel.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation

struct GifsModel: Codable {
    let data: [GifInfo]
    let pagination: Pagination
}

struct GifInfo: Codable {
    /// By default, this is almost always GIF.
    let type: String
    /// This GIF's unique ID
    let id: String
    /// The unique URL for this GIF
    let url: String
    /// An object containing data for various available formats and sizes of this GIF.
    let images: GiphyImages
}

struct GiphyImages: Codable {
    /// Data on versions of this GIF with a fixed width of 200 pixels. Good for mobile use.
    let fixedWidth: GiphyImageInfo
    /// Data on a version of this GIF downsized to be under 2mb.
    let downsized: GiphyImageInfo
}

struct GiphyImageInfo: Codable {
    /// The publicly-accessible direct URL for this GIF.
    let url: String
    /// The width of this GIF in pixels.
    let width: String
    /// The height of this GIF in pixels.
    let height: String
    /// The URL for this GIF in .MP4 format.
    let mp4: String?
}

struct Pagination: Codable {
    /// Position in pagination.
    let offset: Int
    /// Total number of items available (not returned on every endpoint).
    let totalCount: Int
    /// Total number of items returned.
    let count: Int
}
