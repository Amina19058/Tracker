//
//  StatisticsItem.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 12.08.2025.
//

struct StatisticsItem {
    let title: String
    let value: Int
    
    init(type: StatisticsType, value: Int) {
        title = type.title
        self.value = value
    }
}

enum StatisticsType {
    case bestPeriod
    case perfectDays
    case completedTrackers
    case averageAmount
    
    var title: String {
        switch self {
        case .bestPeriod:
            return L10n.statisticsBestPeriod
        case .perfectDays:
            return L10n.statisticsPerfectDays
        case .completedTrackers:
            return L10n.statisticsCompletedTrackers
        case .averageAmount:
            return L10n.statisticsAverageAmount
        }
    }
}
