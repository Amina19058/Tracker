//
//  TabBarController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 27.05.2025.
//

import UIKit


final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    private let tabBarStrings = String.TabBar.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        tabBar.tintColor = .ypBlue
        tabBar.backgroundColor = .ypWhite
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = .ypGray
        
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.ypGrayBorder.cgColor
        tabBar.clipsToBounds = true
        
        setupTabs()
    }
    
    func showOnboardingIfNeeded() {
        guard !UserDefaultsService.shared.hasSeenOnboarding else { return }

        let onboardingVC = OnboardingPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true)
    }
    
    private func setupTabs() {
        let trackersNavController = createTrackersNavController()
        
        let statisticsViewController = createStatisticsController()
        
        self.viewControllers = [trackersNavController, statisticsViewController]
    }
    
    private func createTrackersNavController() -> UINavigationController {
        let trackersViewController = TrackersViewController()
                
        let trackersBarItem = UITabBarItem(title: tabBarStrings.trackersTitle,
                                           image: UIImage(named: tabBarStrings.trackersOnImage),
                                           selectedImage: nil)
        trackersViewController.tabBarItem = trackersBarItem
        
        let trackersNavController = UINavigationController(rootViewController: trackersViewController)
        
        return trackersNavController
    }
    
    private func createStatisticsController() -> UIViewController {
        let statisticsViewController = StatisticsViewController()
        
        let statisticsBarItem = UITabBarItem(title: tabBarStrings.statisticsTitle,
                                             image: UIImage(named: tabBarStrings.statisticsOffImage),
                                             selectedImage: UIImage(named: tabBarStrings.statisticsOnImage))
        statisticsViewController.tabBarItem = statisticsBarItem
        
//        let statisticsNavController = UINavigationController(rootViewController: statisticsViewController)
        
        return statisticsViewController
    }
}
