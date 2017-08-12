//
//  SearchPatientsViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 25/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse

class SearchPatientsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    
    //Declare array for all the patients loaded selected
    var allPatients = [String]()
    //Declare array for search results
    var searchResults = [String]()
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load all patients
        
        self.queryForTable()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    @IBAction func searchMenuBTapped(sender: AnyObject) {
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    @IBAction func refreshBTapped(sender: AnyObject) {
            mySearchBar.resignFirstResponder()
            
            mySearchBar.text = ""
            searchResults.removeAll(keepCapacity: false)
            myTableView.reloadData()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }
    
    //query for tableview
    func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Patients")
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
        

        
        let myCell = myTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        myCell.textLabel?.text = searchResults[indexPath.row]
        
        return myCell
        
    }
    // called when keyboard search button pressed
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        mySearchBar.resignFirstResponder()
        
        var patientNameQuery = PFQuery(className: "Consultation")
        patientNameQuery.whereKey("p_name", matchesRegex: "(?i)\(mySearchBar.text)")
        
        var familiyNameQuery = PFQuery(className: "Consultation")
        patientNameQuery.whereKey("family_name", matchesRegex: "(?i)\(mySearchBar.text)")
        
        var generalQuery = PFQuery.orQueryWithSubqueries([patientNameQuery,familiyNameQuery])
        
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
        let familyName = object.objectForKey("family_name") as! String
        
        let fullName = patientName + " " + familyName
           
            
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
