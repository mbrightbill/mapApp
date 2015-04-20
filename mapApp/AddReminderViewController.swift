//
//  AddReminderViewController.swift
//  mapApp
//
//  Created by Matthew Brightbill on 11/3/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AddReminderViewController: UIViewController {
    
    var locationManager : CLLocationManager!
    var selectedAnnotation : MKAnnotation!
    var managedObjectContext : NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        let regionSet = self.locationManager.monitoredRegions
        let regions = regionSet.count
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
    }

 
    @IBAction func didPressAddReminderButton(sender: AnyObject) {
        
        var geoRegion = CLCircularRegion(center: selectedAnnotation.coordinate, radius: 400_000.0, identifier: "Geo Region!")
        println()
        self.locationManager.startMonitoringForRegion(geoRegion)
        
        //insert a new reminder into our DataBase
        var newReminder = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: self.managedObjectContext) as! Reminder
        newReminder.name = "Geo Region!"
        
        // save and check for error
        var error : NSError?
        self.managedObjectContext.save(&error)
        if error != nil {
            println("error: \(error?.localizedDescription)")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("REMINDER_ADDED", object: self, userInfo: ["region": geoRegion])
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
