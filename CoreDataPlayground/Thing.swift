//
//  Thing.swift
//  CoreDataPlayground
//
//  Created by Tom Abraham on 7/31/14.
//  Copyright (c) 2014 Tom Abraham. All rights reserved.
//

import Foundation
import CoreData

public class Thing: NSManagedObject {
  @NSManaged var title: String
  @NSManaged var visible : NSNumber
  @NSManaged var otherThings : NSSet

  class func make(managedObjectContext: NSManagedObjectContext!) -> Thing {
    return NSEntityDescription.insertNewObjectForEntityForName("Thing", inManagedObjectContext: managedObjectContext) as Thing
  }
}