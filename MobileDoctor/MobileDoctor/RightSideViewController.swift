//
//  RightSideViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 09/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class RightSideViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{
    
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var practiceNumTextField: UITextField!
    @IBOutlet weak var medicalPracticeNumTextField: UITextField!
    
    @IBOutlet weak var pAddressTextField: UITextField!
    @IBOutlet weak var postalAddressTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var cellNumTextField: UITextField!
    @IBOutlet weak var faxNumTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    
    loadUserDetails()
          }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //send business card
    @IBAction func sendBTapped(sender: AnyObject) {
        let mailCompView = configureMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail(){
            self.presentViewController(mailCompView, animated: true, completion: nil)
        } else{
            self.showEmailError()
        }
    }
    
    @IBAction func editBTapped(sender: AnyObject) {
        
        var editProfile = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
        editProfile.openerRight = self
        //editProfile.openerLeft = self
        
        let editProfileNav = UINavigationController(rootViewController: editProfile)
        
        self.presentViewController(editProfileNav, animated: true, completion: nil)
        
    }
    
    func loadUserDetails()
    {
        let userFullName = PFUser.currentUser()?.objectForKey("full_name") as! String
        
        //substring first name
        let str = userFullName
        if let space = find(str, " ") {
            let substr = str[str.startIndex..<space]
            userFullNameLabel.text =  "Dr. " + substr
            
            //load user details
            let userPassword = PFUser.currentUser()?.objectForKey("full_name") as! String
            let userEmail = PFUser.currentUser()?.objectForKey("email") as! String
            
            let userPracticeNum = PFUser.currentUser()?.objectForKey("practice_num") as! String
            let userMedicalPracticeNum = PFUser.currentUser()?.objectForKey("medical_practice_num") as! String
            let userPracticeAddress = PFUser.currentUser()?.objectForKey("practice_address") as! String
            let userPostalAddress = PFUser.currentUser()?.objectForKey("postal_address") as! String
            let userPhoneNum = PFUser.currentUser()?.objectForKey("phone_num") as! String
            let userCellphoneNum = PFUser.currentUser()?.objectForKey("cellphone_num") as! String
            let userFaxNum = PFUser.currentUser()?.objectForKey("fax_num") as! String
            
          
            
            userPasswordTextField.text = "Username: " + userPassword
            userEmailTextField.text = "Email: " + userEmail
            
            practiceNumTextField.text = "Practice number: " + userPracticeNum
            medicalPracticeNumTextField.text = "Medical number: " + userMedicalPracticeNum
            pAddressTextField.text = "Practice address: " + userPracticeAddress
            postalAddressTextField.text = "Postal address: " + userPostalAddress
            phoneNumTextField.text = "Work number: " + userPhoneNum
            cellNumTextField.text = "Private number: " + userCellphoneNum
            faxNumTextField.text = "Fax number: " + userFaxNum
            
            let profilePictureObject = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile
            
            profilePictureObject.getDataInBackgroundWithBlock{(imageData:NSData?, error:NSError?) -> Void in
                
                if(imageData != nil)
                {
                    self.profilePictureImage.image = UIImage(data:imageData!)
                }
            }}

    }
    
    func configureMailComposeViewController() -> MFMailComposeViewController{
        let mailCompView = MFMailComposeViewController()
        mailCompView.mailComposeDelegate = self
        
        let userFullName = PFUser.currentUser()?.objectForKey("full_name") as! String
        let userEmail = PFUser.currentUser()?.objectForKey("email") as! String
        let userPracticeAddress = PFUser.currentUser()?.objectForKey("practice_address") as! String
        let userPostalAddress = PFUser.currentUser()?.objectForKey("postal_address") as! String
        let userPhoneNum = PFUser.currentUser()?.objectForKey("phone_num") as! String
        let userCellphoneNum = PFUser.currentUser()?.objectForKey("cellphone_num") as! String
        let userFaxNum = PFUser.currentUser()?.objectForKey("fax_num") as! String
        
        
        let businesscard = "Hello, \n\n " + userFullName + "\n" + userEmail + "\n" + userPracticeAddress + "\n" + userPostalAddress + "\n" + userPhoneNum + "\n" + userCellphoneNum + "\n" + userFaxNum + "\n\n Kind regards,\nDoctor "  as String
        
        mailCompView.setToRecipients([""]) // chosen pharmacist
        mailCompView.setSubject("Business Card")
        mailCompView.setMessageBody(businesscard, isHTML: false)
        
        /*  */
        
        return mailCompView
        
    }
    
    func showEmailError(){
        
        let emailErrorAlert = UIAlertView(title: "Email could not be sent!", message: "Your device cannot send emails. Setup an account and try again.", delegate: self, cancelButtonTitle: "OK")
        emailErrorAlert.show()
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError!){
        
        switch result.value{
            
        case MFMailComposeResultSent.value:
            
            
            println("Mail sent")
            
            break
        case MFMailComposeResultCancelled.value:
            println("Mail Cancelled")
            break
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func sendMessage(sender: AnyObject) {
        var messageVC = MFMessageComposeViewController()
        
        //set sms business card
        let userFullName = PFUser.currentUser()?.objectForKey("full_name") as! String
        let userEmail = PFUser.currentUser()?.objectForKey("email") as! String
        let userPracticeAddress = PFUser.currentUser()?.objectForKey("practice_address") as! String
        let userPostalAddress = PFUser.currentUser()?.objectForKey("postal_address") as! String
        let userPhoneNum = PFUser.currentUser()?.objectForKey("phone_num") as! String
        let userCellphoneNum = PFUser.currentUser()?.objectForKey("cellphone_num") as! String
        let userFaxNum = PFUser.currentUser()?.objectForKey("fax_num") as! String
        
        
        let businesscard = "Hello, \n\n" + userFullName + "\n" + userEmail + "\n" + userPracticeAddress + "\n" + userPostalAddress + "\n" + userPhoneNum + "\n" + userCellphoneNum + "\n" + userFaxNum + "\n\nKind regards,\nDoctor "  as String
        
        messageVC.body = businesscard;
        messageVC.recipients = [""]
        messageVC.messageComposeDelegate = self;
        
        self.presentViewController(messageVC, animated: false, completion: nil)
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch (result.value) {
        case MessageComposeResultCancelled.value:
            println("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.value:
            println("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.value:
            println("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
}
