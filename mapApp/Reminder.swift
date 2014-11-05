//
//  Reminder.swift
//  mapApp
//
//  Created by Matthew Brightbill on 11/5/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import Foundation
import CoreData

class Reminder: NSManagedObject {

    @NSManaged var dateAdded: NSDate
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var name: String
    @NSManaged var radius: NSNumber

}
