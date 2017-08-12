//
//  LeftSideViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 09/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse

class LeftSideViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userProfilePicture: UIImageView!

    //var menuItems:[String] = ["Main","About","Logout"]
    var menuItems:[String] = ["Main","About","Appointments","Consultation","Prescription","Add/Remove Patient","Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        
      loadUserAndPic()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      return menuItems.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
      var myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! UITableViewCell
        
        myCell.textLabel?.text = menuItems[indexPath.row]
        return myCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch (indexPath.row)
        {
        case 0:
        //open main page
            
            var mainPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
            
            var mainPageNav = UINavigationController(rootViewController: mainPageViewController)
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = mainPageNav
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            
        break
            
        case 1:
            //open about page
            var aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
            
            var aboutPageNav = UINavigationController(rootViewController: aboutViewController)
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = aboutPageNav
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        break
        
        case 2:
            //open appointments page
            var appointmentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AppointmentViewController") as! AppointmentViewController
            
            var appointmentPageNav = UINavigationController(rootViewController:appointmentViewController)
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = appointmentPageNav
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        break
            
        case 3:
            //open search page
            var searchPViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TableViewController") as! TableViewController
            
            var searchPatientsNav = UINavigationController(rootViewController:searchPViewController)
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = searchPatientsNav
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        break
            
        case 4:
            //open prescription page
            var prescriptionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PrescriptionViewController") as! PrescriptionViewController
            
            var prescriptionPageNav = UINavigationController(rootViewController:prescriptionViewController)
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = prescriptionPageNav
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
        break
            
        case 5:
            
            //open map page
            var addPatient = self.storyboard?.instantiateViewControllerWithIdentifier("AddPatientViewController") as! AddPatientViewController
            
            var addPatientNav = UINavigationController(rootViewController: addPatient)
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = addPatientNav
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
            
        case 6:
        //log the user out
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("user_name")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            //progress bars would be here, not needed
            
            //PF user logout
            PFUser.logOutInBackgroundWithBlock{(error:NSError?) -> Void in
            
            //Navigate to protected page
            let mainStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
            
            var logInPage:ViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            
            var logInPageNav = UINavigationController(rootViewController:logInPage)
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = logInPageNav
            }
            
        break
        
        default:
            println("Option is not handled")
        
        }
    
    }
    
    @IBAction func refreshBTapped(sender: AnyObject) {
       /* var editProfile = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
        editProfile.openerLeft = self
        
        let editProfileNav = UINavigationController(rootViewController: editProfile)
        
        self.presentViewController(editProfileNav, animated: true, completion: nil)*/
    }
    
    
    func loadUserAndPic()
    {
        let userFullName = PFUser.currentUser()?.objectForKey("full_name") as! String
        userFullNameLabel.text = userFullName
        
        
        
        let profilePictureObject = PFUser.currentUser()!.objectForKey("profile_picture") as! PFFile
        
        profilePictureObject.getDataInBackgroundWithBlock{(imageData:NSData?, error:NSError?) -> Void in
            
            if(imageData != nil)
            {
                self.userProfilePicture.image = UIImage(data:imageData!)
            }
        }

    }

    

}
