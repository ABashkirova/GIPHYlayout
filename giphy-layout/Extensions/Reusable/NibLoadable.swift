//
//  NibLoadable.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import Foundation

import UIKit

/// Ref: https://alisoftware.github.io/swift/generics/2016/01/06/generic-tableviewcells/
protocol NibLoadable: AnyObject {
    static var nib: UINib { get }
}

extension NibLoadable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension NibLoadable where Self: UIView {
    func setupFromNib() {
        guard
            let views = Self.nib.instantiate(withOwner: self, options: nil) as? [UIView]
        else {
            fatalError("Error loading \(self) from nib")
        }
        
        let layoutAttributes: [NSLayoutConstraint.Attribute] = [.top, .leading, .bottom, .trailing]
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            layoutAttributes.forEach { attribute in
                self.addConstraint(NSLayoutConstraint(
                    item: view,
                    attribute: attribute,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: attribute,
                    multiplier: 1,
                    constant: 0.0
                ))
            }
        }
    }
}
