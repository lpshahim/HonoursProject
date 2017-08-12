//
//  AppointmentViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 09/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse

class AppointmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    
    
    @IBOutlet weak var buttonBook: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var patientLabel: UILabel!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var diffSegments: UISegmentedControl!
    @IBOutlet weak var patientNameTextField: UITextField!
    //Declare array for all the patients loaded selected
    var allPatients = [String]()
    //Declare array for search results
    var searchResults = [String]()
    
    
    //declare the dateformatter
    let dateFormat: NSDateFormatter = NSDateFormatter()
    let datePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup date picker
        dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormat.timeStyle = NSDateFormatterStyle.ShortStyle
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        datePicker.addTarget(self, action: Selector("updateDateField:"), forControlEvents:UIControlEvents.ValueChanged)
        dateField.inputView = datePicker
        
        myTableView.hidden = true
        diffSegments.selectedSegmentIndex = 0
        
        queryForTable()
      
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    func updateDateField(sender: UIDatePicker) {
        dateField.text = dateFormat.stringFromDate(sender.date)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func AppointmentMenuBTapped(sender: AnyObject) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)

    }
    
    
    
    func searchAppointments () -> String {
        
        var numObjects : String = "" // the num return objects from query
        
        var query = PFQuery(className:"Appointments")
        query.whereKey("time", equalTo: dateField.text)
        
        println(numObjects) // at this point the value = 0
        
        return numObjects
    }
    
    @IBAction func bookAppointmentBTapped(sender: AnyObject) {
        
        
        if (patientNameTextField.text != "" && dateField.text != "" ){
        
        var booking = PFObject(className: "Appointments")
        booking.setObject(dateField.text, forKey: "time")
        booking.setObject(patientNameTextField.text, forKey: "p_name")
        booking.saveInBackground()
        
       
        
        
        //Display progress
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = "Please wait..."
        
        booking.saveInBackgroundWithBlock{(success:Bool, error:NSError?) -> Void in
        
        //hide progress
        loadingNotification.hide(true)
        
        if (error != nil)
        {
        
        var myAlert = UIAlertController(title:"Alert", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        
        return
        
        }
        
        
        if (success)
        {
        var userMessage = "Your booking was been successful."
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {( action:UIAlertAction!) -> Void in
        
        self.dismissViewControllerAnimated(true, completion:nil)
            self.patientNameTextField.text = ""
            self.dateField.text = ""
        
        })
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        
        }
        }
        }else{
        
            var userMessage = "Enter the missing fields"
            var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {( action:UIAlertAction!) -> Void in
                
                self.dismissViewControllerAnimated(true, completion:nil)
                
            })
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
        patientNameTextField.text = ""
        
    

        
    }
    
    @IBAction func bookingSegment(sender: AnyObject) {
        switch diffSegments.selectedSegmentIndex
        {
        case 0:
            myTableView.hidden = true
            patientNameTextField.enabled = true
            dateField.enabled = true
            dateField.hidden = false
            patientLabel.hidden = false
            dateLabel.hidden = false
            buttonBook.hidden = false
        case 1:
            dateField.hidden = true
            myTableView.hidden = false
            queryForTable()
            buttonBook.hidden = true
            dateLabel.hidden = true
            
            
        default:
            break; 
        }
    }
    
    // Define the query that will provide the data for the table view
    /*func queryForTable() -> PFQuery {
        
        // Start the query object
        var query = PFQuery(className: "Appointments")
        
        // Add a where clause if there is a search criteria
        if mySearchBar.text != "" {
            query.whereKey("searchText", containsString: mySearchBar.text.lowercaseString)
        }
        
        // Order the results
        query.orderByAscending("p_name")
        
        // Return the qwuery object
        return query
    }*/
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }
    
    //query for tableview
    func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Appointments")
        query.orderByAscending("p_name")
        return query
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //Display all patients originally
        /*
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = allPatients[indexPath.row]
        return cell
        */
        
        
        
        let myCell = myTableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! UITableViewCell
        
        myCell.textLabel?.text = searchResults[indexPath.row]
        
        return myCell
        
    }
    // called when keyboard search button pressed
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        myTableView.resignFirstResponder()
        
        var timeQuery = PFQuery(className: "Appointments")
        timeQuery.whereKey("time", matchesRegex: "(?i)\(mySearchBar.text)")
        var patientNameQuery = PFQuery(className: "Appointments")
        patientNameQuery.whereKey("p_name", matchesRegex: "(?i)\(mySearchBar.text)")
        
        
        
        var generalQuery = PFQuery.orQueryWithSubqueries([timeQuery, patientNameQuery])
        
        generalQuery.findObjectsInBackgroundWithBlock{(results: [AnyObject]?, error:NSError?) -> Void in
            
            if error != nil
            {
                var myAlert = UIAlertController(title: "ALERT", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion: nil)
                
                return
            }
            
            if let objects = results as? [PFObject]{
                
                self.searchResults.removeAll(keepCapacity: false)
                
                for object in objects {
                    let patientName = object.objectForKey("p_name") as! String
                    
                    let time = object.objectForKey("time") as! String
                    
                    
                    
                    let fullName = patientName + " " + time
                    
                    
                    self.searchResults.append(fullName)
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    
                    self.myTableView.reloadData()
                    self.mySearchBar.resignFirstResponder()
                }}}
    }
    
    // called when cancel button pressed
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        mySearchBar.resignFirstResponder()
        mySearchBar.text = ""
        searchResults.removeAll(keepCapacity: false)
        myTableView.reloadData()
    }

    

}
