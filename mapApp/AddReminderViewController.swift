//
//  AddReminderViewController.swift
//  mapApp
//
//  Created by Matthew Brightbill on 11/3/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import UIKit
import MapKit

class AddReminderViewController: UIViewController {
    
    var locationManager : CLLocationManager!
    var selectedAnnotation : MKAnnotation!

    override func viewDidLoad() {
        super.viewDidLoad()

        let regionSet = self.locationManager.monitoredRegions
        let regions = regionSet.allObjects
    }

 
    @IBAction func didPressAddReminderButton(sender: AnyObject) {
        
        var geoRegion = CLCircularRegion(center: selectedAnnotation.coordinate, radius: 100.0, identifier: "TestRegion")
        self.locationManager.startMonitoringForRegion(geoRegion)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
