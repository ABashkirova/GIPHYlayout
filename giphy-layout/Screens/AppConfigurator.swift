//
//  AppConfigurator.swift
//  GyphyLayout
//
//  Created by Alexandra Bashkirova on 27.03.2022.
//

import Foundation
import UIKit

struct AppConfigurator {
    private let requestService: RequestServiceURLSession
    private let dataStore: GifsInfoDataStore
    private let giphyService: TrendingGifsService
    private let imageLoader: ImageLoader
    private let pasteboardService: PasteboardServiceProtocol
    private let cameraRollSaver: CameraRollSaveServiceProtocol
    private let permissionService: PermissionServiceProtocol
    
    init() {
        requestService = RequestServiceURLSession()
        dataStore = GifsInfoDataStore()
        giphyService = TrendingGifsService(
            key: EnvironmentConfiguration().apiKey,
            service: requestService,
            dataStore: dataStore)
        imageLoader = ImageLoader(service: requestService)
        pasteboardService = PasteboardService()
        cameraRollSaver = CameraRollSaveService()
        permissionService = PermissionService()
    }
    
    func getMainFeed() -> UIViewController {
        let vc = MainFeedConfigurator(
            trendingGifLoader: giphyService,
            gifLoader:imageLoader
        ).configure()
        
        vc.routeToPreview = getPreview
        return vc 
    }
    
    private func getPreview(_ id: String) -> UIViewController? {
        let configurator = GifPreviewConfigurator(
            dataStore: dataStore,
            gifLoader: imageLoader,
            pasteboardService: pasteboardService,
            cameraRollSaver: cameraRollSaver,
            permissionService: permissionService)
        let vc = configurator.configure(with: id)
        return vc
    }
}
