//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 02.08.2025.
//

import CoreData

protocol CategoryStoreDelegate: AnyObject {
    func storeDidUpdateCategories()
}

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
}

final class TrackerCategoryStore: NSObject {
    weak var delegate: CategoryStoreDelegate?
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    private let trackerStore: TrackerStore
    
    init(context: NSManagedObjectContext, trackerStore: TrackerStore) {
        self.context = context
        self.trackerStore = trackerStore
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)]

        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller

        try? controller.performFetch()
    }
    
    var categories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController?.fetchedObjects,
            let categories = try? objects.map({ try category(from: $0) })
        else { return [] }
        return categories
    }
    
    func addNewCategory(with title: String) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = title
        trackerCategoryCoreData.trackers = NSSet()
        try context.save()
    }
    
    func coreDataCategory(with title: String) -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        return try? context.fetch(fetchRequest).first
    }
    
    private func category(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = categoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }

        let trackers: [Tracker] = (categoryCoreData.trackers as? Set<TrackerCoreData>)?.compactMap {
            try? trackerStore.tracker(from: $0)
        } ?? []

        return TrackerCategory(title: title, trackers: trackers)
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdateCategories()
    }
}
