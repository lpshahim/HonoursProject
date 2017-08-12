//
//  ConsultationViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 09/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse
import MessageUI


class ConsultationViewController: UIViewController, MFMailComposeViewControllerDelegate {

    //Initialize object for current object
    var currentObject : PFObject?
    
    
    @IBOutlet weak var historyTextField: UITextView!
    @IBOutlet weak var patientNameTextField: UITextField!
    @IBOutlet weak var familyNameTextField: UITextField!
    @IBOutlet weak var examinationTextView: UITextView!
    @IBOutlet weak var assessmentTextView: UITextView!
    @IBOutlet weak var planTextView: UITextView!
    
    var objName = ""
    var objSur = ""
    var objCell = ""
    var objMed = ""
    
    
    @IBAction func backBTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        self.edgesForExtendedLayout = UIRectEdge()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var examination = examinationTextView.text
        var assessment = assessmentTextView.text
        var plan = planTextView.text
       
        
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Unwrap the current object object
        if let object = currentObject {
            
            historyTextField.text = object["history"] as! String
            patientNameTextField.text = object["p_name"] as! String
            familyNameTextField.text = object["family_name"] as! String
            var patientName = object["p_name"] as! String
            var patientSurname = object["family_name"] as! String
            var cell_num = object["cell_num"] as! String
            var medical_aid = object["medical_aid"] as! String
            
            objName = patientName
            objSur = patientSurname
            objCell = cell_num
            objMed = medical_aid
            
            
        }
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
    
    
    @IBAction func patientDetailBTapped(sender: AnyObject) {
        
        //view patients details
        
    }

    @IBAction func ConsultMenuBTapped(sender: AnyObject) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)

    }
    
    @IBAction func cancelBTapped(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func submitBTapped(sender: AnyObject) {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
        var strDate = dateFormatter.stringFromDate(NSDate())
        
        
        if (examinationTextView.text != "" || assessmentTextView.text != "" || planTextView.text != ""){
        if let updateObject = currentObject as PFObject? {
            
            var latestConsultation = historyTextField.text + "\n" + strDate + "\n" + examinationTextView.text + "\n" + assessmentTextView.text + "\n" + planTextView.text
            // Update the existing parse object
            
            // Create a string of text that is used by search capabilites
            var searchText = (historyTextField.text + "\n" + patientNameTextField.text + "\n" + familyNameTextField.text + "\n" ).lowercaseString
            //updateObject.setValue(searchText, forKey: "searchText")
            updateObject["searchText"] = searchText
            updateObject["history"] = latestConsultation
            updateObject["p_name"] = patientNameTextField.text
            updateObject["family_name"] = familyNameTextField.text
            
            
            
            
            // Save the data back to the server in a background task
            updateObject.saveEventually()
        } else {
            
            // Create a new parse object
            var updateObject = PFObject(className:"Consultations")
            
            updateObject["history"] = historyTextField.text
            updateObject["p_name"] = patientNameTextField.text
            updateObject["family_name"] = familyNameTextField.text
            
            
            
            // Create a string of text that is used by search capabilites
            var searchText = (historyTextField.text + " " + patientNameTextField.text + " " + familyNameTextField.text ).lowercaseString
            updateObject["searchText"] = searchText
            
            updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            
            // Save the data back to the server in a background task
            updateObject.saveEventually()
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
        }}
    
    @IBAction func patientDetails(sender: AnyObject) {
        
        var patientDetails = "Patient Name: " + objName + "\nPatient Surname: " + objSur + "\nCell Number: " + objCell + "\nMedical Aid: " + objMed
            
        
        // Create the alert controller
        var alertController = UIAlertController(title: "Patient Details", message: patientDetails, preferredStyle: .Alert)
        
        // Create the actions
        var okAction = UIAlertAction(title: "Send", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            let mailCompView = self.configureMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail(){
                self.presentViewController(mailCompView, animated: true, completion: nil)
            } else{
                self.showEmailError()
            }
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
            
        
    }
    
    //mailDetail functions
    func configureMailComposeViewController() -> MFMailComposeViewController{
        let mailCompView = MFMailComposeViewController()
        mailCompView.mailComposeDelegate = self
        
        
        var patientDetails = "Patient Name: " + objName + "\nPatient Surname: " + objSur + "\nCell Number: " + objCell + "\nMedical Aid: " + objMed
        
        mailCompView.setToRecipients([""]) // chosen pharmacist
        mailCompView.setSubject("Patient Details")
        mailCompView.setMessageBody(patientDetails, isHTML: false)
        
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
    
    
}
