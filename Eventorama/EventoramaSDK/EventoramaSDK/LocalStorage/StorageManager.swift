//
//  StorageManager.swift
//  EventoramaSDK
//
//  Created by Manish Kumar on 2021-10-20.
//

import Foundation
import CoreData

protocol LocalStorageProtocol {
    func createNewEvent(action: String) -> EREvent?
    func saveEvent()
    func fetchEvents() -> [EREvent]?
    func deleteEvents(erEvents: [EREvent])
    func createEventsDictionary(erEvents: [EREvent]) -> [[String: Any]] 
}

class StorageManager: LocalStorageProtocol {
    public static let sharedInstance = StorageManager()
    
    private init() {}
    
    let erModelName: String = "EventoramaModel"
    let erBundleId: String = "dev.manishkumar.EventoramaSDK"
    
    /// Since the SDK will be running within a host app, need to use the hardcoded Bundle ID to access data model.
    lazy var persistentContainer: NSPersistentContainer = {
        let erBundle = Bundle(identifier: erBundleId)!
        let erModelURL = erBundle.url(forResource: erModelName, withExtension: "momd")!
        let erManagedObjectModel =  NSManagedObjectModel(contentsOf: erModelURL)!
        let container = NSPersistentContainer(name: erModelName, managedObjectModel: erManagedObjectModel)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Could not load persistent store \(error)")
            }
        })
        
        return container
    }()
    
    lazy var erManagedObjectContext: NSManagedObjectContext = persistentContainer.viewContext
    
    func createNewEvent(action: String) -> EREvent? {
        let erEvent = EREvent(context: erManagedObjectContext)
        erEvent.name = action
        return erEvent
    }
    
    /// Testing seam
    var afterEventSaved: (() -> Void)?
    
    /// Save captured event to local storage
    func saveEvent() {
        if erManagedObjectContext.hasChanges {
            do {
                try erManagedObjectContext.save()
            } catch {
                let error = error as NSError
                fatalError("Could not store events to local storage \(error)")
            }
        }
    }
    
    /// Fetch captured events from the local storage. Since this function gets executed repeatedly on a timer, fetch only
    /// those events which have been captured till now.
    /// - Returns: Events captured till now
    func fetchEvents() -> [EREvent]? {
        let fetchRequest = NSFetchRequest<EREvent>(entityName: "EREvent")
        
        let currentTimestamp = Date().timeIntervalSince1970
        let pred = NSPredicate(format: "timestamp < %f", currentTimestamp)
        fetchRequest.predicate = pred
        
        do {
            let events = try erManagedObjectContext.fetch(fetchRequest)
            print("Total events fetched: ", events.count)
            return events
        } catch let fetchErr {
            print("Failed to fetch events:",fetchErr)
            return nil
        }
    }
    
    /// Delete events which have been transmitted successfully to the backend.
    /// - Parameter erEvents: Events to be deleted
    func deleteEvents(erEvents: [EREvent]) {
        for erEvent in erEvents {
            erManagedObjectContext.delete(erEvent)
        }
        
        do {
            try erManagedObjectContext.save()
        } catch {
            let error = error as NSError
            fatalError("Could not delete events from local storage \(error)")
        }
    }
    
    /// Convert the managed object `EREvent` to a dictionary. This dictionary will be converted to a JSON and sent to the backend.
    /// - Parameter erEvents: Events to be converted
    /// - Returns: Dictionary of events
    func createEventsDictionary(erEvents: [EREvent]) -> [[String: Any]] {
        var eventArray: [[String: Any]] = []
        
        for erEvent in erEvents {
            let keys = Array(erEvent.entity.attributesByName.keys)
            let dict = erEvent.dictionaryWithValues(forKeys: keys)
            eventArray.append(dict)
        }
        
        return eventArray
    }
}
