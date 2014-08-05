//
//  OtherThing.swift
//  CoreDataPlayground
//
//  Created by Tom Abraham on 8/2/14.
//  Copyright (c) 2014 Tom Abraham. All rights reserved.
//

import Foundation
import CoreData

class OtherThing: NSManagedObject {
  @NSManaged var title : String
  @NSManaged var good : NSNumber

  class func make(moc : NSManagedObjectContext) -> OtherThing {
    return NSEntityDescription.insertNewObjectForEntityForName("OtherThing", inManagedObjectContext: moc) as OtherThing
  }
}
