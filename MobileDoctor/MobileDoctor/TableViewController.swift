//
//  TableViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 14/09/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse

class TableViewController: PFQueryTableViewController, UISearchBarDelegate {
    
    var searchResults = [String]()
    

    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "Consultation"
        self.textKey = "p_name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    @IBAction func add(sender: AnyObject) {
        let addPatient = self.storyboard!.instantiateViewControllerWithIdentifier("AddPatientViewController") as! AddPatientViewController
        
        self.navigationController!.pushViewController(addPatient, animated: true)
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!

    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomTableViewCell!
        if cell == nil {
            cell = CustomTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CustomCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let patientName = object?["p_name"] as? String {
            cell.customPatientName.text = patientName
        }
        if let familyName = object?["family_name"] as? String {
            cell.customFamilyName.text = familyName
        }
        
        
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        var detailScene = segue.destinationViewController as! ConsultationViewController
        
        // Pass the selected object to the destination view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let row = Int(indexPath.row)
            detailScene.currentObject = objects?[row] as? PFObject
        }
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        
        // Start the query object
        var query = PFQuery(className: "Consultation")
        
        // Add a where clause if there is a search criteria
        if searchBar.text != "" {
            query.whereKey("searchText", containsString: searchBar.text!.lowercaseString)
        }
        
        // Order the results
        query.orderByAscending("p_name")
        
        // Return the qwuery object
        return query
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }
    @IBAction func patientsMenuBTapped(sender: AnyObject) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    /*//slide actions
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // 1
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
            
            let twitterAction = UIAlertAction(title: "Email", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        // 3
        var rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 4
            let rateMenu = UIAlertController(title: nil, message: "Delete this patient", preferredStyle: .ActionSheet)
            
            let appRateAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default) {
                UIAlertAction in
        
                //delete current object
                

            }

            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            rateMenu.addAction(appRateAction)
            rateMenu.addAction(cancelAction)
            
            
            self.presentViewController(rateMenu, animated: true, completion: nil)
        })
        // 5
        return [shareAction,rateAction]
    }
    */
    
    
    //*******************************************************
    //Delete object with swipe!!! NBBBBBBBBBBBBB
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! UITableViewCell
        cell.textLabel!.text = objects?[indexPath.row]
        
        return cell
    }*/
    //*******************************************************
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        // Clear any search criteria
        searchBar.text = ""
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
        tableView.reloadData()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        // Refresh the table to ensure any data changes are displayed
        tableView.reloadData()
        
        // Delegate the search bar to this table view class
        searchBar.delegate = self
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            // Delete the row from the data source
            let objectToDelete = objects?[indexPath.row] as! PFObject
            objectToDelete.deleteInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // Force a reload of the table - fetching fresh data from Parse platform
                    
                    self.loadObjects()
                } else {
                    // There was a problem, check error.description
                }
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    // called when cancel button pressed
    /*func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchResults.removeAll(keepCapacity: false)
        tableView.reloadData()
    }*/

    @IBAction func returnHome(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    
   
}
