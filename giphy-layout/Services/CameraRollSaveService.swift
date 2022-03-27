//
//  CameraRollSaveService.swift
//  GyphyLayout
//
//  Created by Alexandra Bashkirova on 28.03.2022.
//

import UIKit
import Photos

protocol CameraRollSaveServiceProtocol {
    func savePhoto(data: Data, completion: @escaping (Result<(), Error>) -> Void)
}

final class CameraRollSaveService: CameraRollSaveServiceProtocol {
    func savePhoto(data: Data, completion: @escaping (Result<(), Error>) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .photo, data: data, options: nil)
        }) { (success, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}
