//
//  ViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 08/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
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

    @IBAction func logInBTapped(sender: AnyObject) {
        
        let userEmail = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        
        if (userEmail.isEmpty || userPassword.isEmpty)
        {
            return
        }
        
        
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.labelText = "Logging in..."
        spinningActivity.detailsLabelText = "Please wait"
        
        
        
        PFUser.logInWithUsernameInBackground(userEmail, password: userPassword) { (user:PFUser?, error:NSError?) -> Void in
            
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
          var userMessage = "Welcome to MobileDoctor!"
          
          if (user != nil)
          {
            
            //Remember login state
            let userName:String? = user?.username
            
            //Remember logged in user credentials
            NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "user_name")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            /*let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
            
            var mainPage:MainPageViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
            
            var mainPageNav = UINavigationController(rootViewController:mainPage)*/
            
            
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.builUserInterface()
            
            //appDelegate.window?.rootViewController = mainPageNav
            
          } else {
            
            userMessage = error!.localizedDescription
            var myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
          }
            
            
        }
    }

}

