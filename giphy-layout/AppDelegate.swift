//
//  AppDelegate.swift
//  giphy-layout
//
//  Created by Alexandra Bashkirova on 26.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()
        let feed = MainFeedViewController(nibName: "MainFeedViewController", bundle: .main)
        window?.rootViewController = feed
        window?.makeKeyAndVisible()
        return true
    }
}

