//
//  MapViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 17/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var myMap: MKMapView!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error) -> Void in
         
            if (error != nil) {
            
                println("Error:" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
            
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
                
            } else {
             println("Error with data")
            }
        })
    }
    
    func displayLocationInfo(placemark:CLPlacemark){
    
        self.locationManager.stopUpdatingLocation()
        
        println(placemark.locality)
        println(placemark.postalCode)
        println(placemark.administrativeArea)
        println(placemark.country)
    
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error:NSError!) {
        println("Error: " + error.localizedDescription)
    }
    
    @IBAction func menuBTapped(sender: AnyObject) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    

}
