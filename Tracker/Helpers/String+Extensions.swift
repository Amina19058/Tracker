//
//  String+Extensions.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 27.05.2025.
//

import Foundation

extension String {            
    enum TabBar {
        static let trackersTitle = L10n.trackersTitle
        static let trackersOnImage = "trackers_bar_on"
        static let trackersOffImage = "trackers_bar_off"
        
        static let statisticsTitle = L10n.statisticsTitle
        static let statisticsOnImage = "statistics_bar_on"
        static let statisticsOffImage = "statistics_bar_off"
    }
    
    enum Trackers {
        static let starStubImage = "star_stub"
    }
    
    enum AccessibilityIdentifiers {
        static let trackersTitleLabel = "TrackersTitleLabel"
        static let searchBar = "SearchBar"
        static let stubImage = "StarImage"
        static let stubLabel = "StubLabel"
    }
}
