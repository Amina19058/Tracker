//
//  EditTrackerViewModel.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 13.08.2025.
//

import UIKit

struct TrackerInfo {
    let id: UUID
    var title: String
    var color: UIColor
    var emoji: String
    var schedule: [WeekDay]
    var daysCount: Int
    var category: TrackerCategory
}

final class EditTrackerViewModel {
    private let trackerStore: TrackerStore
    var trackerInfo: TrackerInfo
    
    init(trackerInfo: TrackerInfo, trackerStore: TrackerStore) {
        self.trackerInfo = trackerInfo
        self.trackerStore = trackerStore
    }
    
    func deleteTracker() {
        do {
            try trackerStore.deleteTracker(trackerInfo.id)
        } catch {
            print("Error deleting tracker: \(error)")
        }
    }
    
    func saveTracker() {
        do {
            let updatedTracker = Tracker(
                id: trackerInfo.id,
                title: trackerInfo.title,
                color: trackerInfo.color,
                emoji: trackerInfo.emoji,
                schedule: trackerInfo.schedule
            )

            let categoryTitle = trackerInfo.category.title
            
            let categoryStore = DataStoreManager.shared.categoryStore

            guard let newCategory = categoryStore.coreDataCategory(with: categoryTitle) else {
                print("Category not found: \(categoryTitle)")
                return
            }

            if let oldCategory = try trackerStore.category(for: updatedTracker.id),
               oldCategory != newCategory {
                try trackerStore.moveTracker(updatedTracker, to: newCategory)
            } else {
                try trackerStore.updateTracker(updatedTracker, in: newCategory)
            }
        } catch {
            print("Error saving tracker: \(error)")
        }
    }

    
    var daysCount: Int {
        trackerInfo.daysCount
    }
}
