//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 27.05.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        AnalyticsService.shared.activate()
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let tabbarVC = TabBarController()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabbarVC
        window?.makeKeyAndVisible()
        
        tabbarVC.showOnboardingIfNeeded()
    }
}

