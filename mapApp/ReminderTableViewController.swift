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
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
}
