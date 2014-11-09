//
//  ReminderTableViewController.swift
//  mapApp
//
//  Created by Matthew Brightbill on 11/5/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import UIKit
import CoreData

class ReminderTableViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext : NSManagedObjectContext!
    var fetchedResultsController : NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        //self.tableView.tableHeaderView =
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didGetCloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: appDelegate.persistentStoreCoordinator)
        
        var fetchRequest = NSFetchRequest(entityName: "Reminder")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Reminders")
        self.fetchedResultsController?.delegate = self
        var error : NSError?
        if self.fetchedResultsController?.performFetch(&error) == false {
            println("error: \(error?.localizedDescription)")
        }
    }
    

    func didGetCloudChanges(notification : NSNotification) {
        self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("REMINDER_CELL", forIndexPath: indexPath) as UITableViewCell
        let reminder = self.fetchedResultsController?.fetchedObjects?[indexPath.row] as Reminder
        
        cell.textLabel.text = reminder.name
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController?.managedObjectContext
            context?.deleteObject(self.fetchedResultsController?.objectAtIndexPath(indexPath) as NSManagedObject)
            
            var error: NSError? = nil
            if context?.save(&error) == false {
                println(error?.localizedDescription)
                abort()
            }

        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            println("default")
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        default:
            println("default")
            return
        }

    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
}
