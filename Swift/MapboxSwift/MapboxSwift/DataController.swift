//
//  DataController.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/28/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
    
    // MARK: - Core Data stack
    
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//         */
//        
//        let container = NSPersistentContainer(name: "RealtimeMapping")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
    var persistentContainer: NSPersistentContainer
    
    init(uuid: String) {
//        let mainBundle = Bundle.m
//        let mainBundle = Bundle(for: DataController.classForCoder())
//        NSManagedObjectModel.mergedModel(from: [bundle])!
//        guard let dataModelBundleURL = bundle.url(forResource: "MapBoxSwift", withExtension: "bundle") else {
//            fatalError("no pod bundle URL")
//        }
//        guard let dataModelBundle = Bundle(url: dataModelBundleURL) else {
//            fatalError("no pod bundle")
//        }
//        guard let model = NSManagedObjectModel.mergedModel(from: [dataModelBundle]) else {
//            fatalError("no managed object model")
//        }
        guard let model = NSManagedObjectModel.mergedModel(from: [Bundle.main]) else {
            fatalError("Couldn't find model")
        }
        self.persistentContainer = NSPersistentContainer(name: uuid, managedObjectModel: model)
        super.init()
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print("what what finished loading persistent stores")
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
