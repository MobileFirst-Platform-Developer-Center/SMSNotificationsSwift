//
//  AppDelegate.swift
//  SMSNotificationsSwift
//
//  Created by Eric Garcia on 8/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit
import IBMMobileFirstPlatformFoundation
import IBMMobileFirstPlatformFoundationPush

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize MFPPush
        MFPPush.sharedInstance().initialize()
        
        // Check if application was opened from a notification
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            //handle your notification
            print("Received Notification in didFinishLaunchingWithOptions \(userInfo)")
            
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Received Notification in didReceiveRemoteNotification \(userInfo)")
        
        // display the alert body
        if let notification = userInfo["aps"] as? NSDictionary,
            let alert = notification["alert"] as? NSDictionary,
            let body = alert["body"] as? String {
            showAlert(body)
        }
    }
    
    func showAlert(_ message: String) {
        let alertDialog = UIAlertController(title: "Push Notification", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertDialog.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        
        window!.rootViewController?.present(alertDialog, animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken: Registered device successfully")
        
        // Registers device token with server.
        MFPPush.sharedInstance().sendDeviceToken(deviceToken)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

