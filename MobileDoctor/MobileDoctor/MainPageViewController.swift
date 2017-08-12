//
//  MainPageViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 09/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import MapKit
import MessageUI

class MainPageViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    
    var yourLocation = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lat = locationManager.location.coordinate.latitude
        var lon = locationManager.location.coordinate.longitude
        
        let user = PFUser.currentUser()?.objectForKey("full_name") as! String
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint:PFGeoPoint?, error:NSError?) -> Void in
            
            NSLog("Test log 1") // Never printed
            
            
            if geoPoint != nil {
                
                // Succeeding in getting current location
                NSLog("Got current location successfully") // never printed
                PFUser.currentUser()!.setValue(geoPoint, forKey: "location")
                PFUser.currentUser()!.saveInBackground()
                
                
            } else {
                // Failed to get location
                NSLog("Failed to get current location") // never printed
            }
        }
        
        //get current location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
        
        // 1
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Doctor"
        annotation.subtitle = user
        self.mapView.addAnnotation(annotation)
        
        
        // User's location
        let userGeoPoint = PFUser.currentUser()?.objectForKey("location") as! PFGeoPoint
        // Create a query for places
        var query = PFQuery(className:"_User")
        // Interested in locations near user.
        query.whereKey("location", nearGeoPoint:userGeoPoint)
        // Limit what could be a lot of points.
        query.limit = 10
        // Final list of objects
        //placeObjects = query.findObjects()
        
        
        
        
        
       

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     //Get Users Current Location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error) -> Void in
            
            
            if (error != nil) {
                
                println("Error:" + error.localizedDescription)
                var locValue : CLLocationCoordinate2D = manager.location.coordinate
                let span2 = MKCoordinateSpanMake(0.05, 0.05)
                let long = locValue.longitude;
                let lat = locValue.latitude;
                println(long);
                println(lat);
                let loadlocation = CLLocationCoordinate2D(
                    latitude: lat, longitude: long
                    
                )     
                
                self.mapView.centerCoordinate = loadlocation
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
        
        let local = placemark.locality
        let postal = placemark.postalCode
        let area = placemark.administrativeArea
        let country = placemark.country
        
        var loc = "My location is : \n" + local + "\n" + postal + "\n" + area + "\n" + country
        println(local)
        println(postal)
        println(area)
        println(country)
        println(loc)
        yourLocation = loc
        
        var myAlert = UIAlertController(title: "Alert", message: loc, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title:country, style: UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okAction)
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error:NSError!) {
        println("Error: " + error.localizedDescription)
    }

    
    //Dont know what right side will do yet!!!!
    @IBAction func RightSideBTapped(sender: AnyObject) {
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }
    
    //Menu Button Tapped
    @IBAction func MenuBTapped(sender: AnyObject) {
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }

    func configureMailComposeViewController() -> MFMailComposeViewController{
        
        let mailCompView = MFMailComposeViewController()
        mailCompView.mailComposeDelegate = self
        
        var lat = locationManager.location.coordinate.latitude
        var lon = locationManager.location.coordinate.longitude
     
            
        
        
        
        let locationSend = "Hello, \n\n " + yourLocation + "\nLatitude: \(lat) \nLongitude: \(lon)"  as String
        
        mailCompView.setToRecipients([""]) // chosen recipient
        mailCompView.setSubject("Location")
        mailCompView.setMessageBody(locationSend, isHTML: false)
        
        /*  */
        
        return mailCompView
        
    }
    
    func showEmailError(){
        
        let emailErrorAlert = UIAlertView(title: "Email could not be sent!", message: "Your device cannot send emails. Setup an account and try again.", delegate: self, cancelButtonTitle: "OK")
        emailErrorAlert.show()
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError!){
        
        switch result.value{
            
        case MFMailComposeResultSent.value:
            
            
            println("Mail sent")
            
            break
        case MFMailComposeResultCancelled.value:
            println("Mail Cancelled")
            break
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendLocation(sender: AnyObject) {
        
        let mailCompView = configureMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail(){
            self.presentViewController(mailCompView, animated: true, completion: nil)
        } else{
            self.showEmailError()
        }
    }
    
    
    
}
