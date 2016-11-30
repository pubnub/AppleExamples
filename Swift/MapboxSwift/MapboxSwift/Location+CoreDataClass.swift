//
//  Location+CoreDataClass.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/29/16.
//  Copyright © 2016 PubNub. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
import CoreLocation

@objc(Location)
public class Location: NSManagedObject {
    
    static func create(with location: CLLocationCoordinate2D, in context: NSManagedObjectContext) -> Location {
        var createdLocation: Location? = nil
        context.performAndWait {
            createdLocation = Location(context: context)
            createdLocation!.latitude = location.latitude
            createdLocation!.longitude = location.longitude
        }
        return createdLocation!
    }

}
