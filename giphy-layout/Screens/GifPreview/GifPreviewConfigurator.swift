//
//  GifPreviewConfigurator.swift
//  GyphyLayout
//
//  Created by Alexandra Bashkirova on 27.03.2022.
//

import Foundation
import UIKit

struct GifPreviewConfigurator {
    private let dataStore: GifsInfoDataStoreProtocol
    private let gifLoader: ImageLoaderProtocol
    private let pasteboardService: PasteboardServiceProtocol
    private let cameraRollSaver: CameraRollSaveServiceProtocol
    private let permissionService: PermissionServiceProtocol
    
    init(
        dataStore: GifsInfoDataStoreProtocol,
        gifLoader: ImageLoaderProtocol,
        pasteboardService: PasteboardServiceProtocol,
        cameraRollSaver: CameraRollSaveServiceProtocol,
        permissionService: PermissionServiceProtocol
    ) {
        self.dataStore = dataStore
        self.gifLoader = gifLoader
        self.pasteboardService = pasteboardService
        self.cameraRollSaver = cameraRollSaver
        self.permissionService = permissionService
    }
    
    func configure(with gifId: String) -> UIViewController? {
        guard let model = dataStore.preview(for: gifId) else { return nil }
        let presenter = GifPreviewPresenter(
            model: model,
            gifLoader: gifLoader,
            pasteboardService: pasteboardService,
            cameraRollSaver: cameraRollSaver,
            permissionService: permissionService)
        
        let vc = GifPreviewViewController(presenter: presenter)
        presenter.setInteractionInput(vc)
        
        vc.routeToShare = routeToShare
        vc.routeToSettings = routeToSettings
        
        return vc
    }
    
    private func routeToShare(_ data: Data, _ sourceView: UIView) -> UIViewController {
        let shareData = NSData(data: data)
        let gifData: [Any] = [shareData as Any]
        let activityViewController = UIActivityViewController(
            activityItems: gifData,
            applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sourceView
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.postToTwitter,
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.addToReadingList,
        ]
        return activityViewController
    }
    
    private func routeToSettings() {
        guard let settings = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settings, options: [:], completionHandler: nil)
    }
}
