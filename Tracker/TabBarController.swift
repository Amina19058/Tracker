//
//  TabBarController.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 27.05.2025.
//

import UIKit


class TabBarController: UITabBarController, UITabBarControllerDelegate {
    private let tabBarStrings = String.TabBar.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.tabBar.tintColor = .ypBlue
        self.tabBar.backgroundColor = .ypWhite
        self.tabBar.unselectedItemTintColor = .ypGray
        
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = UIColor.ypGray.cgColor
        self.tabBar.clipsToBounds = true
        
        setupTabs()
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
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
