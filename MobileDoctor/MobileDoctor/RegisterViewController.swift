//
//  RegisterViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 08/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //new register values
    @IBOutlet weak var practiceNumTextField: UITextField!
    @IBOutlet weak var medicalPracticeNumTextField: UITextField!
    
    @IBOutlet weak var pAddressTextField: UITextField!
    @IBOutlet weak var postalAddressTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var cellNumTextField: UITextField!
    @IBOutlet weak var faxNumTextField: UITextField!
    
    
    
    
    @IBOutlet weak var userFullNameTextField: UITextField!
    @IBOutlet weak var userEmailAddressTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userPasswordRepeatTextField: UITextField!
    
    

    @IBOutlet weak var profilePictureImageView: UIImageView!
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
    
    @IBAction func selectProfilePictureBTapped(sender: AnyObject) {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        profilePictureImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    @IBAction func cancelBTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func registerBTapped(sender: AnyObject) {
        
        
        
        
        let userName = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        let userPasswordRepeat = userPasswordRepeatTextField.text
        let userFullName = userFullNameTextField.text
        let userPracticeNum = practiceNumTextField.text
        let userMedicalPracticeNum = medicalPracticeNumTextField.text
        let userPracticeAddress = pAddressTextField.text
        let userPostalAddress = postalAddressTextField.text
        let userPhoneNum = phoneNumTextField.text
        let userCellphoneNum = cellNumTextField.text
        let userFaxNum = faxNumTextField.text
        
        if (userName.isEmpty || userPassword.isEmpty || userPasswordRepeat.isEmpty || userFullName.isEmpty || userPracticeNum.isEmpty || userMedicalPracticeNum.isEmpty || userPhoneNum.isEmpty || userPracticeAddress.isEmpty || userPostalAddress.isEmpty || userCellphoneNum.isEmpty || userFaxNum.isEmpty)
        {
            var myAlert = UIAlertController(title: "Alert", message: "All text fields are required", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
            
            return
        }
        
        if (userPassword != userPasswordRepeat)
        {
            var myAlert = UIAlertController(title: "Alert", message: "Passwords do not match. Try again!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
            
            return
        }
        
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.labelText = "Registering..."
        spinningActivity.detailsLabelText = "Please wait"
        
        var myUser = PFUser()
        
        let imageData = UIImageJPEGRepresentation(profilePictureImageView.image, 0.05)
        let imageFile = PFFile( data:imageData)
         myUser.setObject(imageFile, forKey: "profile_picture")
        imageFile.save()
       
        
        myUser.username = userName
        myUser.password = userPassword
        myUser.email = userName
        myUser.setObject(userFullName, forKey: "full_name")
        myUser.setObject(userPracticeNum, forKey: "practice_num")
        myUser.setObject(userMedicalPracticeNum, forKey: "medical_practice_num")
        myUser.setObject(userPracticeAddress, forKey: "practice_address")
        myUser.setObject(userPostalAddress, forKey: "postal_address")
        myUser.setObject(userPhoneNum, forKey: "phone_num")
        myUser.setObject(userCellphoneNum, forKey: "cellphone_num")
        myUser.setObject(userFaxNum, forKey: "fax_num")
        
        
        
        myUser.signUpInBackgroundWithBlock { (success:Bool, error:NSError?)-> Void in
        
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
            var userMessage = "Successfully registered. Welcome, Doc!"
            
            if (!success)
            {
            //userMessage = "Unsuccessful registration! Try again later."
            userMessage = error!.localizedDescription
            }
            
            var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.Default){ action in
            
            if (success)
            {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
            
        myAlert.addAction(okAction)
            
        self.presentViewController(myAlert, animated: true, completion: nil)
        
        }
        
        
        
    }
    

}
