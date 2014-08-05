//
//  ListingViewController.swift
//  CoreDataPlayground
//
//  Created by Tom Abraham on 8/3/14.
//  Copyright (c) 2014 Tom Abraham. All rights reserved.
//

import UIKit
import CoreData

class ListingViewController: UIViewController, ThingAddViewControllerDelegate {
  let listingView : ListingView!

  let thingsViewController : ThingsViewController!
  let otherThingsViewController : OtherThingsViewController

  let moc : NSManagedObjectContext

  required init(coder aDecoder: NSCoder!) {
    fatalError("NSCoding not supported")
  }

  init(managedObjectContext moc : NSManagedObjectContext) {
    otherThingsViewController = OtherThingsViewController(managedObjectContext: moc)

    self.moc = moc

    super.init(nibName: nil, bundle: nil)

    self.edgesForExtendedLayout = .None

    thingsViewController = ThingsViewController(delegate: self, managedObjectContext: moc)

    addChildViewController(thingsViewController)
    addChildViewController(otherThingsViewController)
    listingView = ListingView(
      thingsView: thingsViewController.view,
      otherThingsView: otherThingsViewController.view
    )
    thingsViewController.didMoveToParentViewController(self)
    otherThingsViewController.didMoveToParentViewController(self)

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .Add, target: self, action: "addSelected"
    )

    navigationItem.leftBarButtonItem = UIBarButtonItem(
    barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "removeRandom")
  }

  override func loadView() {
    view = listingView
  }

  // MARK: ThingAddViewControllerDelegate

  func thingAddViewControllerDismissWasRequested(thingAddVC: ThingAddViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  func thingAddViewControllerSaveWasRequested(thingAddVC: ThingAddViewController) {
    var error : NSError?
    moc.save(&error)

    if let error = error { NSLog("%@", error); abort() }
  }

  // MARK: Actions

  func addSelected() {
    let addViewController = ThingAddViewController(
      mode: .Add,
      managedObjectContext: moc,
      delegate: self
    )

    presentViewController(
      UINavigationController(rootViewController: addViewController),
      animated: true,
      completion: nil
    )
  }

}
