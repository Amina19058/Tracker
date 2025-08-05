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
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]

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
    
    var records: [TrackerRecord] {
        guard let objects = fetchedResultsController?.fetchedObjects else { return [] }
        return objects.compactMap { record(from: $0) }
    }

    func addNewRecord(_ record: TrackerRecord) {
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.trackerId = record.trackerId
        recordCoreData.date = record.date
        
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", record.trackerId as CVarArg)
        fetchRequest.fetchLimit = 1

        if let trackerCoreData = try? context.fetch(fetchRequest).first {
            recordCoreData.tracker = trackerCoreData
        }

        try? context.save()
    }
    
    func removeRecord(_ record: TrackerRecord) throws {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: record.date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return }

        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "trackerId == %@", record.trackerId as CVarArg),
            NSPredicate(format: "date >= %@", startOfDay as NSDate),
            NSPredicate(format: "date < %@", endOfDay as NSDate)
        ])

        let results = try context.fetch(fetchRequest)
        print("Found records to delete: \(results.count)")

        for object in results {
            context.delete(object)
        }

        try context.save()
    }


    func record(trackerId: UUID, date: Date) throws -> TrackerRecord? {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "trackerId == %@", trackerId as CVarArg),
            NSPredicate(format: "date == %@", date as CVarArg)
        ])
        fetchRequest.fetchLimit = 1

        let result = try context.fetch(fetchRequest).first
        return result.flatMap { record(from: $0) }
    }

    private func record(from recordCoreData: TrackerRecordCoreData) -> TrackerRecord? {
        guard
            let trackerId = recordCoreData.trackerId,
            let date = recordCoreData.date
        else {
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
