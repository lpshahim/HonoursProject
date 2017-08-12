//
//  AddPatientViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 15/09/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse

class AddPatientViewController: UIViewController {

    @IBOutlet weak var newPatientNameTextField: UITextField!
    @IBOutlet weak var newPatientSurnameTextField: UITextField!
    @IBOutlet weak var newPatientMedAidTextField: UITextField!
    @IBOutlet weak var newPatientCellNumTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func addPatientBTapped(sender: AnyObject) {
        
        //get time of add String
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        var strDate = dateFormatter.stringFromDate(NSDate())
        
        
        let pName = newPatientNameTextField.text
        let sName = newPatientSurnameTextField.text
        let medAid = newPatientMedAidTextField.text
        let cellNum = newPatientCellNumTextField.text
        
        let addSearch = pName + " " + sName
        
        if (pName != "" && sName != "" && medAid != "" && cellNum != ""){

            
        var newPatient = PFObject(className: "Consultation")
        newPatient.setObject(pName, forKey: "p_name")
        newPatient.setObject(sName, forKey: "family_name")
        newPatient.setObject(medAid, forKey: "medical_aid")
        newPatient.setObject(cellNum, forKey: "cell_num")
        newPatient.setObject(addSearch, forKey: "searchText")
        newPatient.setObject("Added at: " + strDate, forKey: "history")
        //newPatient.saveInBackground()
            //Display progress
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.labelText = "Please wait..."
            
            newPatient.saveInBackgroundWithBlock{(success:Bool, error:NSError?) -> Void in
                
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
                    var userMessage = "Added patient successfully."
                    var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {( action:UIAlertAction!) -> Void in
                        
                        self.dismissViewControllerAnimated(true, completion:nil)
                        self.newPatientNameTextField.text = ""
                        self.newPatientSurnameTextField.text = ""
                        self.newPatientMedAidTextField.text = ""
                        self.newPatientCellNumTextField.text = ""
                    })
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    
                }}
            
        }else{
        
            var userMessage = "Enter the missing fields"
            var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {( action:UIAlertAction!) -> Void in
                
                self.dismissViewControllerAnimated(true, completion:nil)
                
            })
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
        
    }

    @IBAction func cancelBTapped(sender: AnyObject) {
        
    }
    
    @IBAction func menuBTapped(sender: AnyObject) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    @IBAction func profileBTapped(sender: AnyObject) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }

}
