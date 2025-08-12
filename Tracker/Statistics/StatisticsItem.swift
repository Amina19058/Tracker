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
        title = type.rawValue
        self.value = value
    }
}

enum StatisticsType: String {
    case bestPeriod = "bestPeriod"
    case perfectDays = "perfectDays"
    case completedTrackers = "completedTrackers"
    case averageAmount = "averageAmount"
}
