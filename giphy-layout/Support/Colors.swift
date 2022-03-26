//
//  Colors.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import UIKit

enum Colors: String {
    case background = "Background"
    
    enum MainPalette: String, CaseIterable {
        case pastelRed = "PastelRed"
        case dodieYellow = "DodieYellow"
        case mediumSpringGreen = "MediumSpringGreen"
        case purple = "Purple"
        case skyBlue = "SkyBlue"
        
        var uiColor: UIColor {
            UIColor(named: rawValue)!
        }
    }
    
    var uiColor: UIColor {
        UIColor(named: rawValue)!
    }
}

extension UIColor {
    static var mainBackgroundColor = Colors.background.uiColor
    
    static var pastelRed = Colors.MainPalette.pastelRed.uiColor
    static var dodieYellow = Colors.MainPalette.dodieYellow.uiColor
    static var mediumSpringGreen = Colors.MainPalette.mediumSpringGreen.uiColor
    static var purple = Colors.MainPalette.purple.uiColor
    static var skyBlue = Colors.MainPalette.skyBlue.uiColor
}
