//
//  PasswordResetViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 10/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse

class PasswordResetViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelBTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func sendBTapped(sender: AnyObject) {
      
        let email = emailAddressTextField.text
        
        if (email.isEmpty)
        {
            let userMessage:String = "Enter your email address."
            displayMessage(userMessage)
            return
        }
        
        PFUser.requestPasswordResetForEmailInBackground(email, block: {(success:Bool, error:NSError?) -> Void in
            
            if (error != nil)
            {
                //display error message
                let userMessage:String = error!.localizedDescription
                self.displayMessage(userMessage)
            }else{
                //display success message
                let userMessage:String = "An email was sent to you \(email)"
                self.displayMessage(userMessage)
            }
        })
        
    }
    
    func displayMessage(userMessage:String)
    {
        var myAlert = UIAlertController(title:"Alert",message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default){action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated:true,completion:nil)
    
    }
    

}
