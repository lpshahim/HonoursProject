//
//  AppDelegate.swift
//  MobileDoctor
//
//  Created by Louis-Philip Shahim on 08/08/2015.
//  Copyright (c) 2015 Louis-Philip Shahim. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerContainer : MMDrawerController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("4gfP2eRxkyzwM9UQ90zivuiZ0Va92iybfE4eKV56",
            clientKey: "P1m0IpSuD7fY6mW6F7J2GJ2Uzti7o6N24DvyOBBc")
        
        //*********************************************
        //Initialize pfquerytableviewcontroller
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        /*if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes(types)
        }*/
        
        //PUSH NOTIFICATIONS
        let userNotificationTypes = (UIUserNotificationType.Alert |  UIUserNotificationType.Badge |  UIUserNotificationType.Sound);
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
            // Store the deviceToken in the current Installation and save it to Parse
            let installation = PFInstallation.currentInstallation()
            installation.setDeviceTokenFromData(deviceToken)
            installation.saveInBackground()
        }
        
        
        
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //LOGIN CREDENTIALS VALID AND CONTINUE TO ProtectedPage*****************************************************************
        
        /* let userName:String? = NSUserDefaults.standardUserDefaults().stringForKey("user_name")
        
        if(userName != nil)
        {
            //Navigate to protected page
            let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
            
            var mainPage:MainPageViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
            
            var mainPageNav = UINavigationController(rootViewController:mainPage)
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = mainPageNav
        
        }*/
        //**********************************************************************************************************************Replaced with sidebar code
        
    builUserInterface()
        
        return true
    }
    
    //Store device token
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func builUserInterface()
    {
        let userName:String? = NSUserDefaults.standardUserDefaults().stringForKey("user_name")
        
        if(userName != nil)
        {
            //Navigate to protected page
            let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
            
            //Create view controllers for left, centre and right side
            var mainPage:MainPageViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
            
            var leftSideMenu:LeftSideViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LeftSideViewController") as! LeftSideViewController
            
            var rightSideMenu:RightSideViewController = mainStoryboard.instantiateViewControllerWithIdentifier("RightSideViewController") as! RightSideViewController
            
            //Wrape into navigation controllers
            var mainPageNav = UINavigationController(rootViewController:mainPage)
            var leftSideMenuNav = UINavigationController(rootViewController:leftSideMenu)
            var rightSideMenuNav = UINavigationController(rootViewController:rightSideMenu)
            
            
            drawerContainer = MMDrawerController(centerViewController: mainPageNav, leftDrawerViewController: leftSideMenuNav, rightDrawerViewController: rightSideMenuNav)
            
            drawerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
            drawerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
            
            
            
            window?.rootViewController = drawerContainer
            
        } else {
        
        }
    
    }
    
    

}

