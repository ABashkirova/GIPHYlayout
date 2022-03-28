//
//  GifPreviewPresenter.swift
//  GyphyLayout
//
//  Created by Alexandra Bashkirova on 27.03.2022.
//

import Foundation

protocol GifPreviewPresentationOutput {
    func didLoadModule()
    func didRequestedCopyLinkGif()
    func didRequestedCopyGif()
    func didRequestToSaveToCameraRoll()
    func didRequestShare()
}

final class GifPreviewPresenter: GifPreviewPresentationOutput {
    private let gifLoader: ImageLoaderProtocol
    private let pasteboardService: PasteboardServiceProtocol
    private let cameraRollSaver: CameraRollSaveServiceProtocol
    private let permissionService: PermissionServiceProtocol
    
    private(set) weak var interactionInput: GifPreviewInteractionInput?
    private let model: GifPreviewPresentationModel
    private var data: Data?
    
    init(
        model: GifPreviewPresentationModel,
        gifLoader: ImageLoaderProtocol,
        pasteboardService: PasteboardServiceProtocol,
        cameraRollSaver: CameraRollSaveServiceProtocol,
        permissionService: PermissionServiceProtocol
    ) {
        self.model = model
        self.gifLoader = gifLoader
        self.pasteboardService = pasteboardService
        self.cameraRollSaver = cameraRollSaver
        self.permissionService = permissionService
    }
    
    func setInteractionInput(_ interactionInput: GifPreviewInteractionInput) {
        self.interactionInput = interactionInput
    }
    
    func didLoadModule() {
        guard let url = URL(string: model.url) else {
            return 
        }
        gifLoader.load(url: url) { [weak self] result in
            guard let data = result else {
                self?.interactionInput?.showMessage(.errorLoading)
                return
            }
            self?.updateImage(data: data)
        }
    }
    
    func didRequestedCopyLinkGif() {
        guard let link = URL(string: model.url) else { return }
        pasteboardService.setLink(link: link)
        interactionInput?.showMessage(.copied)
    }
    
    func didRequestedCopyGif() {
        guard let data = data else { return }
        pasteboardService.setGif(data: data)
        interactionInput?.showMessage(.copied)
    }
    
    func didRequestToSaveToCameraRoll() {
        guard let data = data else { return }
        switch permissionService.photoLibraryPermissionStatus() {
        case .denied:
            interactionInput?.openSettings()
        case .authorized:
            saveGif(data: data)
        case .notDetermined:
            permissionService.requestPhotoLibraryPermission { [weak self] status in
                self?.handleReceivedCameraPermission(status, dataToSave: data)
            }
        }
    }
    
    func didRequestShare() {
        guard let data = data else { return }
        interactionInput?.share(data: data)
    }
    
    private func updateImage(data: Data) {
        interactionInput?.setupImage(model: GifPreviewModel(data: data))
        self.data = data
    }
    
    private func saveGif(data: Data) {
        cameraRollSaver.savePhoto(data: data) { [weak self] result in
            switch result {
            case .success:
                self?.interactionInput?.showMessage(.savedToCameraRoll)
            case .failure:
                self?.interactionInput?.showMessage(.failedSaveToCameraRoll)
            }
        }
    }
    
    private func handleReceivedCameraPermission(_ status: PhotoPermissionStatus, dataToSave: Data) {
        guard case .authorized = status else {
            interactionInput?.openSettings()
            return
        }
        saveGif(data: dataToSave)
    }
}
