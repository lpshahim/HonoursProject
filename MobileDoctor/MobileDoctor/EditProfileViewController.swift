//
//  EditProfileViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 10/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var practiceNumTextField: UITextField!
    @IBOutlet weak var medicalPracticeNumTextField: UITextField!
    @IBOutlet weak var pAddressTextField: UITextField!
    @IBOutlet weak var postalAddressTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var cellNumTextField: UITextField!
    @IBOutlet weak var faxNumTextField: UITextField!
    
    //openers to refresh the updated profiles
    var openerRight: RightSideViewController!
    var openerLeft: LeftSideViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)

        //load user details
        let userFullName = PFUser.currentUser()?.objectForKey("full_name") as! String
        let userPracticeNum = PFUser.currentUser()?.objectForKey("practice_num") as! String
        let userMedicalPracticeNum = PFUser.currentUser()?.objectForKey("medical_practice_num") as! String
        let userPracticeAddress = PFUser.currentUser()?.objectForKey("practice_address") as! String
        let userPostalAddress = PFUser.currentUser()?.objectForKey("postal_address") as! String
        let userPhoneNum = PFUser.currentUser()?.objectForKey("phone_num") as! String
        let userCellphoneNum = PFUser.currentUser()?.objectForKey("cellphone_num") as! String
        let userFaxNum = PFUser.currentUser()?.objectForKey("fax_num") as! String
        
        fullNameTextField.text = userFullName
        
        practiceNumTextField.text = userPracticeNum
        medicalPracticeNumTextField.text = userMedicalPracticeNum
        pAddressTextField.text = userPracticeAddress
        postalAddressTextField.text = userPostalAddress
        phoneNumTextField.text = userPhoneNum
        cellNumTextField.text = userCellphoneNum
        faxNumTextField.text = userFaxNum
        
    if(PFUser.currentUser()?.objectForKey("profile_picture") != nil )
        {
            let userImageFile:PFFile = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile
            
            userImageFile.getDataInBackgroundWithBlock({(imageData:NSData?, error:NSError?) -> Void in
                if (imageData != nil)
                {
                self.profilePictureImageView.image = UIImage(data:imageData!)
                }
            })
            
        }
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

    @IBAction func doneBTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func chooseProfilePictureBTapped(sender: AnyObject) {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }

    @IBAction func saveBTapped(sender: AnyObject) {
        
        //get user
        let myUser:PFUser = PFUser.currentUser()!
        
        //get profile image data
        let profileImageData = UIImageJPEGRepresentation(profilePictureImageView.image, 0.05)
        
        //check if all fields are empty
        if (fullNameTextField.text.isEmpty && practiceNumTextField.text.isEmpty && medicalPracticeNumTextField.text.isEmpty && pAddressTextField.text.isEmpty && postalAddressTextField.text.isEmpty && phoneNumTextField.text.isEmpty && cellNumTextField.text.isEmpty && faxNumTextField.text.isEmpty && profileImageData == nil )
        {
            var myAlert = UIAlertController(title:"Alert",message: "Empty fields", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:nil)
            
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
            
            return
            
        }
        
        //set new values for fields
       let newUserFullName = fullNameTextField.text
       let newUserPracticeNum = practiceNumTextField.text
       let newUserMedicalPracticeNum = medicalPracticeNumTextField.text
       let newUserPracticeAddress = pAddressTextField.text
       let newUserPostalAddress = postalAddressTextField.text
       let newUserPhoneNum = phoneNumTextField.text
       let newUserCellphoneNum = cellNumTextField.text
       let newUserFaxNum = faxNumTextField.text
        
        //change user values on Parse
        myUser.setObject(newUserFullName, forKey: "full_name")
        myUser.setObject(newUserPracticeNum, forKey: "practice_num")
        myUser.setObject(newUserMedicalPracticeNum, forKey: "medical_practice_num")
        myUser.setObject(newUserPracticeAddress, forKey: "practice_address")
        myUser.setObject(newUserPostalAddress, forKey: "postal_address")
        myUser.setObject(newUserPhoneNum, forKey: "phone_num")
        myUser.setObject(newUserCellphoneNum, forKey: "cellphone_num")
        myUser.setObject(newUserFaxNum, forKey: "fax_num")
        
        //new profile picture
        if(profileImageData != nil)
        {
            let profileFileObject = PFFile(data:profileImageData)
            myUser.setObject(profileFileObject, forKey: "profile_picture")
        }
        
        //Display progress
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = "Please wait..."
        
        myUser.saveInBackgroundWithBlock{(success:Bool, error:NSError?) -> Void in
            
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
            var userMessage = "\(newUserFullName)" + ", your profile has been successfully updated"
            var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {( action:UIAlertAction!) -> Void in
                
                self.dismissViewControllerAnimated(true, completion: {() -> Void in
                    self.openerRight.loadUserDetails()
                
                    
                })
                /*self.dismissViewControllerAnimated(true, completion: {() -> Void in
                    self.openerLeft.loadUserAndPic()
                    
                    
                })*/
                })
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated: true, completion: nil)
            
        }
    }
  
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        profilePictureImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
