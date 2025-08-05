//
//  TrackerStore.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 02.08.2025.
//

import UIKit
import CoreData

enum TrackerStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidTitle
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidSchedule
}

struct TrackerStoreUpdate {
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

protocol TrackerStoreDelegate: AnyObject {
    func store(
        _ store: TrackerStore,
        didUpdate update: TrackerStoreUpdate
    )
}

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?

    weak var delegate: TrackerStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()

        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.title, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        guard let title = trackerCoreData.title else {
            throw TrackerStoreError.decodingErrorInvalidTitle
        }
        guard let color = trackerCoreData.color as? UIColor else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }
        guard let scheduleRaw = trackerCoreData.schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }

        let schedule = scheduleRaw as? [WeekDay] ?? []

        return Tracker(id: id, title: title, color: color, emoji: emoji, schedule: schedule)
    }

    func addNewTracker(_ tracker: Tracker, to category: TrackerCategoryCoreData) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        
        updateExistingTracker(trackerCoreData, with: tracker)
        category.addToTrackers(trackerCoreData)
        
        try context.save()
    }
    
    private func updateExistingTracker(_ trackerCoreData: TrackerCoreData, with tracker: Tracker) {
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = tracker.color
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as NSArray
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerStoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else {
                assertionFailure("indexPath (for .insert) should not be nil")
                return
            }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else {
                assertionFailure("indexPath (for .delete) should not be nil")
                return
            }
            deletedIndexes?.insert(indexPath.item)
        case .update: break
        case .move: break
        default:
            assertionFailure("Unsupported NSFetchedResultsChangeType: \(type)")
        }
    }
}
