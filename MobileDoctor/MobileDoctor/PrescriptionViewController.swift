//
//  PrescriptionViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 09/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import MessageUI
import Parse

class PrescriptionViewController: UIViewController,MFMailComposeViewControllerDelegate,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var medicineTextView: UITextView!
    @IBOutlet weak var dosageTextView: UITextView!
    
    //Declare array for all the patients loaded selected
    var allPatients = [String]()
    //Declare array for search results
    var searchResults = [String]()
    
    var objEmail = ""
    var objName = ""
    var objCell = ""
    var objMed = ""
    var objDos = ""
    var objDoc = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let userEmail = PFUser.currentUser()?.objectForKey("email") as! String
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        self.edgesForExtendedLayout = UIRectEdge()
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
    
    @IBAction func sendBTapped(sender: AnyObject) {
        
        /*let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
        
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) in
            let loginTextField = alertController.textFields![0] as! UITextField
            let passwordTextField = alertController.textFields![1]as! UITextField
            
            login(loginTextField.text, passwordTextField.text)
        }
        loginAction.enabled = false
        
        let forgotPasswordAction = UIAlertAction(title: "Forgot Password", style: .Destructive) { (_) in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Login"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                loginAction.enabled = textField.text != ""
            }
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        }
        
        alertController.addAction(loginAction)
        alertController.addAction(forgotPasswordAction)
        alertController.addAction(cancelAction)*/
        
        
        
        let med = medicineTextView.text
        let dos = dosageTextView.text
        if (med != "" && dos != ""){
            
            let alertController = UIAlertController(title: "Prescription", message: "Please input your email:", preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (_) in
                if let field = alertController.textFields![0] as? UITextField {
                    // store your data
                    NSUserDefaults.standardUserDefaults().setObject(field.text, forKey: "user_name")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    let mailCompView = self.configureMailComposeViewController()
                    
                    if MFMailComposeViewController.canSendMail(){
                        var prescription = PFObject(className: "Prescription")
                        prescription.setObject(med, forKey: "medication")
                        prescription.setObject(dos, forKey: "dosage")
                        prescription.setObject(self.objEmail, forKey: "toEmail")
                        prescription.setObject(self.objDoc, forKey: "fromDoctor")
                        prescription.saveInBackground()
                        self.objMed = med
                        self.objDos = dos
                        self.presentViewController(mailCompView, animated: true, completion: nil)
                    } else{
                        self.showEmailError()
                    }
                    
                } else {
                    var userMessage = "Enter the missing fields"
                    var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {( action:UIAlertAction!) -> Void in
                        
                        //self.dismissViewControllerAnimated(true, completion:nil)
                        
                    })
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Email"
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        }
        
        
        
        
    }
    
    @IBAction func PrescriptionMenuBTapped(sender: AnyObject) {
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)

    }
    
   
    
    func configureMailComposeViewController() -> MFMailComposeViewController{
    let mailCompView = MFMailComposeViewController()
        mailCompView.mailComposeDelegate = self
        
        
        
        let docName = PFUser.currentUser()?.objectForKey("full_name") as! String
        let docMPNumber = PFUser.currentUser()?.objectForKey("medical_practice_num") as! String
        let docPNumber = PFUser.currentUser()?.objectForKey("practice_num") as! String
    
    mailCompView.setToRecipients([objEmail]) // chosen pharmacist
    mailCompView.setSubject(docName)
    mailCompView.setMessageBody("Hello " + objName + ",\n\n MP NUMBER: " + docMPNumber + "\n PRACTICE NUMBER: " + docPNumber + "\n\n Patients Information:\n Name:\n Medical Aid Number:\n Address:\n\n PRESCRIBED:\n Medication: " + objMed + "\nDosage: " + objDos + "\n\n Regards,\nDr. " +  docName, isHTML: false)
        
        objDoc = docName
        
        
      return mailCompView
        
    }
    
    func showEmailError(){
    
        let emailErrorAlert = UIAlertView(title: "Email could not be sent!", message: "Your device cannot send emails. Setup an account and try again.", delegate: self, cancelButtonTitle: "OK")
        emailErrorAlert.show()
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError!){
    
        switch result.value{
        
        case MFMailComposeResultSent.value:
            //add prescription to prescription class
            let med = medicineTextView.text
            let dos = dosageTextView.text
            
            /*var prescription = PFObject(className: "Prescription")
            prescription.setObject(med, forKey: "medication")
            prescription.setObject(dos, forKey: "dosage")
            prescription.saveInBackground()*/
            objMed = med
            objDos = dos
            println("Mail sent")
            //medicineTextView.text = ""
            //dosageTextView.text = ""
            break
        case MFMailComposeResultCancelled.value:
            println("Mail Cancelled")
            break
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Search pharmacists
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }
    
    //query for tableview
    func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Pharmacists")
        query.orderByAscending("full_name")
        return query
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let myCell = myTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        myCell.textLabel?.text = searchResults[indexPath.row]
        
        return myCell
        
    }
    // called when keyboard search button pressed
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        myTableView.resignFirstResponder()
        
        var fulNameQuery = PFQuery(className: "Pharmacists")
        fulNameQuery.whereKey("full_name", matchesRegex: "(?i)\(mySearchBar.text)")
        var pharmacistEmailQuery = PFQuery(className: "Pharmacists")
        pharmacistEmailQuery.whereKey("email", matchesRegex: "(?i)\(mySearchBar.text)")
        
        
        
        var generalQuery = PFQuery.orQueryWithSubqueries([fulNameQuery, pharmacistEmailQuery])
        
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
                    let pharmacistName = object.objectForKey("full_name") as! String
                    
                    let email = object.objectForKey("email") as! String
                    
                    let pharmacistCell = object.objectForKey("cellphone_num") as! String
                    
                    
                    //let fullDetails = pharmacistName + " " + email
                    
                    
                    self.searchResults.append(pharmacistName)
                    
                    self.objEmail = email
                    self.objName = pharmacistName
                    self.objCell = pharmacistCell
                    
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
        medicineTextView.text = ""
        dosageTextView.text = ""
    }

    

}
