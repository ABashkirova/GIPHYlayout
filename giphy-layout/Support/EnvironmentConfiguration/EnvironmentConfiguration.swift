//
//  EnvironmentConfiguration.swift
//  GyphyLayout
//
//  Created by Alexandra Bashkirova on 27.03.2022.
//

import Foundation

protocol GyphyEnvironmentConfiguration {
    var apiKey: String { get }
}

final class EnvironmentConfiguration: GyphyEnvironmentConfiguration {
    var apiKey: String {
        "2DvJJTjzG77VFsRxeGpLqjeLWPX2B5Dy"
    }
}
