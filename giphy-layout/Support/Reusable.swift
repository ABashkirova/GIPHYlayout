//
//  Reusable.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import UIKit

/// Ref: https://alisoftware.github.io/swift/generics/2016/01/06/generic-tableviewcells/
protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

typealias NibReusable = Reusable & NibLoadable

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
