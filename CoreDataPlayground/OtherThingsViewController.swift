//
//  OtherThingsViewController.swift
//  CoreDataPlayground
//
//  Created by Tom Abraham on 8/3/14.
//  Copyright (c) 2014 Tom Abraham. All rights reserved.
//

import UIKit
import CoreData

private let kCell = "kCell"

class OtherThingsViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {
  let fetchedResultsController : NSFetchedResultsController
  let managedObjectContext : NSManagedObjectContext
  let tableView = UITableView(frame: CGRectNull, style: .Grouped)

  required init(coder: NSCoder!) {
    fatalError("NSCoding not supported")
  }

  init(managedObjectContext moc : NSManagedObjectContext) {
    managedObjectContext = moc

    let fetchRequest = NSFetchRequest(entityName: "OtherThing")
    fetchRequest.predicate = NSPredicate(format: "good = YES")
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

    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kCell)
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

  // MARK: UITableViewDataSource

  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    let otherThing = fetchedResultsController.objectAtIndexPath(indexPath) as OtherThing

    let cell = tableView.dequeueReusableCellWithIdentifier(kCell, forIndexPath: indexPath) as UITableViewCell
    cell.textLabel.text = otherThing.title
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
      tableView.deleteRowsAtIndexPaths([ indexPath ], withRowAnimation: UITableViewRowAnimation.Top)

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
