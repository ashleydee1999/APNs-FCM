//
//  CoreDataManager.swift
//  FCMAppTut
//
//  Created by Ashley Dube on 2022/07/28.
//

import SwiftUI
import CoreData
import UserNotifications

extension Notification.Name {
    static let didReceiveNotification = Notification.Name(rawValue: "com.travsim.DidReceiveNotification")
}

final class CoreDataManager {
    private let modelName: String
    
    //MARK: - Initializer
    
    init(modelName: String) {
        self.modelName = modelName
        setupNotificationHandling()
    }
    
    //MARK: - ManagedObjectContext
    
    //MARK: Parent ManagedObjectContext
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistantStoreCoordinator
        return context
    }()
    
    //MARK: Child ManagedObjectContext
    
    private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.privateManagedObjectContext
        return context
    }()
    
    //MARK: - ManagedObjectModel
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let dataModelUrl = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else { fatalError("unable to find data model url") }
        guard let dataModel = NSManagedObjectModel(contentsOf: dataModelUrl) else { fatalError("unable to find data model") }
        return dataModel
    }()
    
    //MARK: - PersistantStoreCoordinator
    
    private lazy var persistantStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.travsim.FCMAppTut")!
        let storeUrl =  directory.appendingPathComponent(storeName)
        do {
            //MARK: for LightWeight Migration ---
            let options = [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true,
            ]
            // -------
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
        } catch {
            fatalError("unable to add store")
        }
        return coordinator
    }()
    
    //MARK: - Save
    
    func saveChanges() {
        mainManagedObjectContext.perform {
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                }
            } catch {
                print("saving error : child : - \(error.localizedDescription)")
            }
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                }
            } catch {
                print("saving error : parent : - \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Helper Methods
    
    @objc func saveChanges(notificaiton: Notification) {
        saveChanges()
    }
    private func setupNotificationHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveChanges(notificaiton:)), name:  UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveChanges(notificaiton:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
}
