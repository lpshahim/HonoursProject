//
//  PatientDetailViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 21/09/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit

class PatientDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelBTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
