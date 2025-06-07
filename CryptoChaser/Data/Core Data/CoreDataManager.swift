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

protocol CoreDataStack {
    static var shared: Self { get }
    var persistentContainer: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
    func saveContext()
    func performFetchRequest<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T]
}

final class MockCoreDataManager: CoreDataStack {
    static let shared = MockCoreDataManager()
    private let logger = Logger()
    internal lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
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

final class CoreDataManager: CoreDataStack {
    static let shared = CoreDataManager()
    private let logger = Logger()
    
    internal lazy var persistentContainer: NSPersistentContainer = {
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
