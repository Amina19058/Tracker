//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 09.08.2025.
//

final class TrackersViewModel {
    private let trackerStore: TrackerStore
    private let categoryStore: TrackerCategoryStore
    
    var onDataChanged: (() -> Void)?
    
    init(trackerStore: TrackerStore, categoryStore: TrackerCategoryStore) {
        self.trackerStore = trackerStore
        self.categoryStore = categoryStore
        
        trackerStore.delegate = self
        categoryStore.delegate = self
    }
}

extension TrackersViewModel: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        onDataChanged?()
    }
}

extension TrackersViewModel: CategoryStoreDelegate {
    func storeDidUpdateCategories() {
        onDataChanged?()
    }
}
