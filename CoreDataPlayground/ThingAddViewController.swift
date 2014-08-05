//
//  ThingAddViewController.swift
//  CoreDataPlayground
//
//  Created by Tom Abraham on 7/31/14.
//  Copyright (c) 2014 Tom Abraham. All rights reserved.
//

import UIKit
import CoreData

@objc protocol ThingAddViewControllerDelegate {
  func thingAddViewControllerDismissWasRequested(thingAddVC : ThingAddViewController)
  func thingAddViewControllerSaveWasRequested(thingAddVC : ThingAddViewController)
}

enum ThingAddViewControllerMode {
  case Add
  case Edit(NSManagedObjectID)
}

class ThingAddViewController: UIViewController {
  weak var delegate : ThingAddViewControllerDelegate?
  let managedObjectContext : NSManagedObjectContext

  let addView = ThingAddView()

  let mode : ThingAddViewControllerMode

  let thing : Thing

  required init(coder aDecoder: NSCoder!) {
    fatalError("NSCoding not supported")
  }

  init(mode: ThingAddViewControllerMode, managedObjectContext moc: NSManagedObjectContext, delegate: ThingAddViewControllerDelegate?) {
    switch mode {
    case let .Edit(thingID):
      let thingie = moc.objectWithID(thingID) as Thing
      thingie.title = "TEST"
    default:
      ()
    }

    let childMOC = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    childMOC.parentContext = moc
    self.managedObjectContext = childMOC

    self.delegate = delegate

    self.mode = mode

    switch mode {
    case .Add:
      thing = Thing.make(childMOC)

    case let .Edit(thingID):
      thing = childMOC.objectWithID(thingID) as Thing
      addView.titleTextField.text = thing.title

      if thing.otherThings.count > 0 {
        let otherThing = thing.otherThings.anyObject() as OtherThing
        addView.otherThingTitleTextField.text = otherThing.title
      }
    }

    super.init(nibName: nil, bundle: nil)

    self.edgesForExtendedLayout = .None

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneSelected")
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelSelected")
  }

  override func loadView() {
    view = addView
  }

  func cancelSelected() {
    delegate?.thingAddViewControllerDismissWasRequested(self)
  }

  func doneSelected() {
    var error : NSError?

    thing.title = addView.titleTextField.text
    thing.visible = true

    let otherThing = OtherThing.make(managedObjectContext)
    otherThing.title = addView.otherThingTitleTextField.text
    otherThing.good = true
    thing.otherThings = NSSet(array: [ otherThing ])

    managedObjectContext.performBlockAndWait({ self.managedObjectContext.save(&error); () })

    delegate?.thingAddViewControllerSaveWasRequested(self)

    if let error = error { NSLog("%@", error); abort() }

    delegate?.thingAddViewControllerDismissWasRequested(self)
  }
}