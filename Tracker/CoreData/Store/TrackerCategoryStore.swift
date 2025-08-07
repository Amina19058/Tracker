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
    private let trackerStore: TrackerStore
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    init(context: NSManagedObjectContext, trackerStore: TrackerStore) {
        self.context = context
        self.trackerStore = trackerStore
        super.init()
        setupFetchedResultsController()
    }

    var categories: [TrackerCategory] {
        guard
            let objects = fetchedResultsController?.fetchedObjects,
            let categories = try? objects.map({ try category(from: $0) })
        else {
            return []
        }
        return categories
    }

    func addNewCategory(with title: String) throws {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = title
        categoryCoreData.trackers = NSSet()
        try context.save()
    }

    func coreDataCategory(with title: String) -> TrackerCategoryCoreData? {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    private func setupFetchedResultsController() {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        
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

    private func category(from coreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = coreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }

        let trackers: [Tracker] = (coreData.trackers as? Set<TrackerCoreData>)?.compactMap {
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
