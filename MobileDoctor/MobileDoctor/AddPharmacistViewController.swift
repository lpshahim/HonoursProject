//
//  AddPharmacistViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 24/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse

class AddPharmacistViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var cellphoneTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
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

    @IBAction func cancelBTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    @IBAction func saveBTapped(sender: AnyObject) {
        
        let fullName = fullNameTextField.text
        let email = emailAddressTextField.text
        let cell = cellphoneTextField.text
        let city = cityTextField.text
        
        if (fullName != "" && email != "" && cell != "" && city != ""){
        
        var pharmacist = PFObject(className: "Pharmacists")
        pharmacist.setObject(fullName, forKey: "full_name")
        pharmacist.setObject(email, forKey: "email")
        pharmacist.setObject(cell, forKey: "cellphone_num")
        pharmacist.setObject(city, forKey: "city")
        //pharmacist.saveInBackground()
            //Display progress
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.labelText = "Please wait..."
            
            pharmacist.saveInBackgroundWithBlock{(success:Bool, error:NSError?) -> Void in
                
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
                    var userMessage = "Added pharmacist successfully"
                    var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {( action:UIAlertAction!) -> Void in
                        
                        self.dismissViewControllerAnimated(true, completion:nil)
                        self.fullNameTextField.text = ""
                        self.emailAddressTextField.text = ""
                        self.cellphoneTextField.text = ""
                        self.cityTextField.text = ""
                        
                    })
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    
                }
            }
        }else{
            
            var userMessage = "Enter the missing fields"
            var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {( action:UIAlertAction!) -> Void in
                
                //self.dismissViewControllerAnimated(true, completion:nil)
                
            })
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
        
   
        
    }
    
    

}
