//
//  DataStoreManager.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 05.08.2025.
//

final class DataStoreManager {
    static let shared = DataStoreManager()

    let trackerStore: TrackerStore
    let categoryStore: TrackerCategoryStore
    let recordStore: TrackerRecordStore

    private init() {
        let context = PersistentContainer.shared.persistentContainer.viewContext
        let trackerStore = try! TrackerStore(context: context)
        self.trackerStore = trackerStore
        self.categoryStore = TrackerCategoryStore(context: context, trackerStore: trackerStore)
        self.recordStore = TrackerRecordStore(context: context)
    }
}
