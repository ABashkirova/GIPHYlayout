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
        let requestService = RequestServiceURLSession()
        let giphyService = TrendingGifsService(key: EnvironmentConfiguration().apiKey, service: requestService)
        let feed = MainFeedConfigurator(
            trendingGifLoader: giphyService,
            gifLoader: ImageLoader(service: requestService))
            .configure()
        window?.rootViewController = feed
        window?.makeKeyAndVisible()
        return true
    }
}

