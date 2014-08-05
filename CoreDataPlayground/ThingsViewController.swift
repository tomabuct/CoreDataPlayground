//
//  ThingsViewController.swift
//  CoreDataPlayground
//
//  Created by Tom Abraham on 7/31/14.
//  Copyright (c) 2014 Tom Abraham. All rights reserved.
//

import UIKit
import CoreData

private let kCell2 = "kCell"

class ThingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
  weak var delegate : ThingAddViewControllerDelegate?

  let fetchedResultsController : NSFetchedResultsController
  let managedObjectContext : NSManagedObjectContext
  let tableView = UITableView(frame: CGRectNull, style: .Grouped)

  required init(coder aDecoder: NSCoder!) {
    fatalError("NSCoding not supported")
  }

  init(delegate : ThingAddViewControllerDelegate, managedObjectContext moc : NSManagedObjectContext) {
    managedObjectContext = moc
    self.delegate = delegate

    let fetchRequest = NSFetchRequest(entityName: "Thing")
    fetchRequest.predicate = NSPredicate(format: "visible = YES")
    fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "title", ascending: true) ]

    fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: managedObjectContext,
      sectionNameKeyPath: nil,
      cacheName: nil
    )

    super.init(nibName: nil, bundle: nil)

    fetchedResultsController.delegate = self
    var error : NSError?
    fetchedResultsController.performFetch(&error)

    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kCell2)
    tableView.delegate = self
    tableView.dataSource = self
  }

  override func loadView() {
    view = tableView
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow(), animated: animated)
  }

  // MARK: UITableViewDelegate

  func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
    let thing : Thing = fetchedResultsController.objectAtIndexPath(indexPath) as Thing

    let addViewController = ThingAddViewController(
      mode: .Edit(thing.objectID),
      managedObjectContext: managedObjectContext,
      delegate: delegate
    )
    
    presentViewController(
      UINavigationController(rootViewController: addViewController),
      animated: true,
      completion: nil
    )
  }

  func tableView(tableView: UITableView!, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle {
    return .Delete
  }

  func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    switch (editingStyle) {
    case .Delete:
      let thing = fetchedResultsController.objectAtIndexPath(indexPath) as Thing
      managedObjectContext.deleteObject(thing)

      var error : NSError?
      managedObjectContext.save(&error)
      if let error = error { NSLog("\(error)"); abort() }
    default:
      ()
    }
  }

  // MARK: UITableViewDataSource

  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    let thing : Thing = fetchedResultsController.objectAtIndexPath(indexPath) as Thing

    let cell = tableView.dequeueReusableCellWithIdentifier(kCell2, forIndexPath: indexPath) as UITableViewCell
    cell.textLabel.text = thing.title
    return cell
  }

  func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
    let sectionInfo = fetchedResultsController.sections[section] as NSFetchedResultsSectionInfo
    return sectionInfo.numberOfObjects
  }

  func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
   return fetchedResultsController.sections.count
  }

  func controllerWillChangeContent(controller: NSFetchedResultsController!)  {
    tableView.beginUpdates()
    mustReload = false
  }
  var mustReload = false

  func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
    let tableView = self.tableView
    switch (type) {
    case NSFetchedResultsChangeType.Insert:
      tableView.insertRowsAtIndexPaths([ newIndexPath ], withRowAnimation: UITableViewRowAnimation.Bottom)

    case .Delete:
      tableView.deleteRowsAtIndexPaths([ indexPath ], withRowAnimation: UITableViewRowAnimation.Bottom)

    default:
      mustReload = true
      // noop
    }
  }

  // MARK: NSFetchedResultsControllerDelegate
  func controllerDidChangeContent(controller: NSFetchedResultsController!)  {
    tableView.endUpdates()
    if mustReload {
      self.tableView.reloadData()
    }

    NSLog("\(managedObjectContext.registeredObjects)")
  }
}
