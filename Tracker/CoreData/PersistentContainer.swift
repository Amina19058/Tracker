//
//  PersistentContainer.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 03.08.2025.
//

import CoreData

final class PersistentContainer {
    static let shared = PersistentContainer()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Tracker")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Could not load persistent stores: \(error)")
            }
        })
        
        DaysValueTransformer.register()
        ColorTransformer.register()
    }
}
