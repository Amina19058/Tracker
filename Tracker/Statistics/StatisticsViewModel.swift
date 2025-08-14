//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 12.08.2025.
//

import Foundation

final class StatisticsViewModel {
    private let store: TrackerRecordStore
    
    var onStatisticsChanged: (() -> Void)?
    
    private(set) var statistics: [StatisticsItem] = [] {
        didSet {
            self.onStatisticsChanged?()
        }
    }
    
    init(recordStore: TrackerRecordStore) {
        store = recordStore
        store.delegate = self
        calculateStatistics()
    }
    
    private func calculateStatistics() {
        let allRecords = store.records
        guard !allRecords.isEmpty else {
            statistics = []
            return
        }

        let calendar = Calendar.current
        
        let completedTrackersCount = allRecords.count
        
        let groupedByDate = Dictionary(grouping: allRecords, by: { calendar.startOfDay(for: $0.date) })
        let totalTrackersCount = Set(allRecords.map { $0.trackerId }).count
        let _ = groupedByDate.values.filter { $0.count == totalTrackersCount }.count // perfectDaysCount
        
        let sortedDates = Array(groupedByDate.keys).sorted()
        var bestStreak = 0
        var currentStreak = 0
        var previousDate: Date?

        for date in sortedDates {
            if let prev = previousDate,
               calendar.date(byAdding: .day, value: 1, to: prev) == date {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
            bestStreak = max(bestStreak, currentStreak)
            previousDate = date
        }

        statistics = [
            StatisticsItem(type: .bestPeriod, value: 0),
            StatisticsItem(type: .perfectDays, value: 0),
            StatisticsItem(type: .completedTrackers, value: completedTrackersCount),
            StatisticsItem(type: .averageAmount, value: 0)
        ]
    }
    
    func recalculateNow() {
        calculateStatistics()
    }
}

extension StatisticsViewModel: RecordStoreDelegate {
    func storeDidUpdateRecords() {
        calculateStatistics()
    }
}
