//
//  User+CoreDataClass.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/29/16.
//  Copyright © 2016 PubNub. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
import CoreLocation

@objc(User)
public class User: NSManagedObject {
    
    enum UserError: Error {
        case noUUID
    }
    
    static func fetch(user uuid: String, in context: NSManagedObjectContext) -> User? {
        var firstResult: User? = nil
        
        context.performAndWait {
            let matchingUserFetchRequest: NSFetchRequest<User> = User.fetchRequest()
            let userSortDescriptors = NSSortDescriptor(key: #keyPath(User.uuid), ascending: true)
            matchingUserFetchRequest.sortDescriptors = [userSortDescriptors]
            matchingUserFetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
            do {
                let results = try matchingUserFetchRequest.execute()
                firstResult = results.first
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        return firstResult
    }
    
    static func createOrFetch(user uuid: String, in context: NSManagedObjectContext) -> User {
        
        var firstResult: User? = fetch(user: uuid, in: context)
        if firstResult == nil {
            context.performAndWait {
                firstResult = User(context: context)
                firstResult!.uuid = uuid
            }
        }
        return firstResult!
        
//        
//        
//        context.performAndWait {
//            let matchingUserFetchRequest: NSFetchRequest<User> = User.fetchRequest()
//            let userSortDescriptors = NSSortDescriptor(key: #keyPath(User.uuid), ascending: true)
//            matchingUserFetchRequest.sortDescriptors = [userSortDescriptors]
//            matchingUserFetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
//            do {
//                let results = try matchingUserFetchRequest.execute()
//                firstResult = results.first
//            } catch {
//                fatalError(error.localizedDescription)
//            }
//            if firstResult == nil {
//                firstResult = User(context: context)
//                firstResult!.uuid = uuid
//            }
//        }
//        return firstResult!
    }
    
    static func createOrUpdate(values: [String: Any], in context: NSManagedObjectContext) throws -> User {
        guard let uuid = values["uuid"] as? String else {
            throw UserError.noUUID
        }
        let user = createOrFetch(user: uuid, in: context)
        
        context.performAndWait {
            if let name = values["name"] as? String {
                user.name = name
            }
            if let location = values["location"] as? CLLocationCoordinate2D {
                user.location = Location.create(with: location, in: context)
            }
        }
        return user
        
    }

}
