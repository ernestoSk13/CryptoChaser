//
//  CoreDataManager.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import Foundation
import CoreData
import OSLog


enum CoreDataError: Error {
    case fetchRequestFailed
}

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let logger = Logger()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        //Add support for lightweight migration
        if let description = container.persistentStoreDescriptions.first {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                logger.log("Failed to save context: \(error)")
            }
        }
    }
    
    func performFetchRequest<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T] {
        let context = persistentContainer.viewContext
        do {
            let data = try context.fetch(request)
            return data
        } catch {
            throw CoreDataError.fetchRequestFailed
        }
    }
    
    // Ensures that the Core Data operations are done without blocking the UI
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
