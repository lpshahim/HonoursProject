//
//  AboutViewController.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 09/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

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
    @IBAction func aboutUsMenuBTapped(sender: AnyObject) {
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)

    }

    @IBAction func WebLink(sender: AnyObject) {
        if let url = NSURL(string: "http://elitesporthockey.biz") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
