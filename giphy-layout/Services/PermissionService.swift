//
//  PermissionService.swift
//  GyphyLayout
//
//  Created by Alexandra Bashkirova on 28.03.2022.
//

import UIKit
import Photos

enum PhotoPermissionStatus {
    case notDetermined
    case authorized
    case denied
}

protocol PermissionServiceProtocol {
    func photoLibraryPermissionStatus() -> PhotoPermissionStatus
    func requestPhotoLibraryPermission(result: @escaping (_ status: PhotoPermissionStatus) -> ())
}

final class PermissionService: PermissionServiceProtocol {
    func photoLibraryPermissionStatus() -> PhotoPermissionStatus {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            return .authorized
        case .notDetermined:
            return .notDetermined
        case .restricted, .denied, .limited:
            return .denied
        @unknown default:
            return .denied
        }
    }
    
    func requestPhotoLibraryPermission(result: @escaping (_ status: PhotoPermissionStatus) -> ()) {
        PHPhotoLibrary.requestAuthorization() { status in
            DispatchQueue.main.async() {
                switch status {
                case .authorized:
                    result(.authorized)
                case .notDetermined:
                    result(.notDetermined)
                case .restricted, .denied, .limited:
                    result(.denied)
                @unknown default:
                    result(.denied)
                }
            }
        }
    }
}
