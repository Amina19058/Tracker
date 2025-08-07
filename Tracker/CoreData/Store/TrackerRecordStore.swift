//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 02.08.2025.
//

import CoreData

protocol RecordStoreDelegate: AnyObject {
    func storeDidUpdateRecords()
}

final class TrackerRecordStore: NSObject {
    weak var delegate: RecordStoreDelegate?
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        setupFetchedResultsController()
    }
    
    var records: [TrackerRecord] {
        fetchedResultsController?.fetchedObjects?.compactMap { self.record(from: $0) } ?? []
    }

    func addNewRecord(_ record: TrackerRecord) {
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.trackerId = record.trackerId
        recordCoreData.date = record.date
        
        if let trackerCoreData = fetchTracker(by: record.trackerId) {
            recordCoreData.tracker = trackerCoreData
        }

        saveContext()
    }
    
    func removeRecord(_ record: TrackerRecord) throws {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: record.date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return }

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "trackerId == %@", record.trackerId as CVarArg),
            NSPredicate(format: "date >= %@", startOfDay as NSDate),
            NSPredicate(format: "date < %@", endOfDay as NSDate)
        ])

        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = predicate

        if let results = try? context.fetch(fetchRequest) {
            results.forEach { context.delete($0) }
            saveContext()
        }
    }

    func record(trackerId: UUID, date: Date) -> TrackerRecord? {
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "trackerId == %@", trackerId as CVarArg),
            NSPredicate(format: "date == %@", date as CVarArg)
        ])

        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1

        return try? context.fetch(fetchRequest).first.flatMap { record(from: $0) }
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]

        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        fetchedResultsController = controller

        try? controller.performFetch()
    }

    private func fetchTracker(by id: UUID) -> TrackerCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1

        return try? context.fetch(fetchRequest).first
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    private func record(from coreData: TrackerRecordCoreData) -> TrackerRecord? {
        guard let trackerId = coreData.trackerId,
              let date = coreData.date else {
            return nil
        }
        return TrackerRecord(trackerId: trackerId, date: date)
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidUpdateRecords()
    }
}
