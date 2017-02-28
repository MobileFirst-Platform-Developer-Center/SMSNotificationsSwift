//
//  ViewController.swift
//  SMSNotificationsSwift
//
//  Created by Eric Garcia on 8/8/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit
import IBMMobileFirstPlatformFoundation
import IBMMobileFirstPlatformFoundationPush

// MARK: Variables and Helper Methods
class ViewController: UIViewController {

    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var getTagsBtn: UIButton!
    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var getSubscriptionBtn: UIButton!
    @IBOutlet weak var unsubscribeBtn: UIButton!
    @IBOutlet weak var unregisterDeviceBtn: UIButton!
    
    // Array to hold tags
    var tagsArray: [String] = []
    
    
    func enableButtons(){
        registerBtn.isEnabled = false
        subscribeBtn.isEnabled = true
        getSubscriptionBtn.isEnabled = true
        unsubscribeBtn.isEnabled = true
        unregisterDeviceBtn.isEnabled = true
    }
    
    func disableButtons(){
        registerBtn.isEnabled = true
        subscribeBtn.isEnabled = false
        getSubscriptionBtn.isEnabled = false
        unsubscribeBtn.isEnabled = false
        unregisterDeviceBtn.isEnabled = false
    }

    func showAlert(_ message: String) {
        let alertDialog = UIAlertController(title: "Push Notification", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertDialog.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertDialog, animated: true, completion: nil)
    }

}

// MARK: Lifecycle Methods
extension ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.disableButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Buttons and Text Fields
extension ViewController {
    
    @IBAction func isPushSupported(_ sender: AnyObject) {
        print("Is push supported entered")
        
        let isPushSupported: Bool = MFPPush.sharedInstance().isPushSupported()
        
        if isPushSupported {
            showAlert("Yes, Push is supported")
        } else {
            showAlert("No, Push is not supported")
        }
    }
    
    @IBAction func registerDevice(_ sender: AnyObject) {
        print("Register device entered")
        
        // TODO: Validate phone number
        
        let phoneNumber: String = self.phoneNumberTF.text!
        
        if phoneNumber == "" {
            self.showAlert("Please enter a phone number")
        } else {
            let jsonOptions: [AnyHashable: Any] = [
                "phoneNumber": phoneNumber
            ]
            
            // Vlaidate JSON before sending to register device.
            if JSONSerialization.isValidJSONObject(jsonOptions) {
                
                print("jsonOptions is valid: \(jsonOptions)")
                
                // Register device
                MFPPush.sharedInstance().registerDevice(jsonOptions) { (response, error) -> Void in
                    if error == nil {
                        self.enableButtons()
                        self.showAlert("Registered successfully! " + "With phone number: " + phoneNumber)
                        
                        print(response?.description ?? "")
                    } else {
                        self.showAlert("Registrations failed.  Error \(error?.localizedDescription)")
                        print(error?.localizedDescription ?? "")
                    }
                }
 //               MFPPush.sharedInstance().registerDevice(jsonOptions, completionHandler: {(response: WLResponse!, error: NSError!) -> Void in
 //                   if error == nil {
 //                       self.enableButtons()
 //                       self.showAlert("Registered successfully! " + "With phone number: " + phoneNumber)
                        
  //                      print(response.description)
   //                 } else {
  //                      self.showAlert("Registrations failed.  Error \(error.description)")
  //                      print(error.description)
  //                  }
  //              })
                
            }
            
        }
    }

    @IBAction func getTags(_ sender: AnyObject) {
        print("Get tags entered")
        
        // Get tags
        MFPPush.sharedInstance().getTags { (response, error) -> Void in
            if error == nil {
                print("The response is: \(response)")
                print("The response text is \(response?.responseText)")
                if response?.availableTags().isEmpty == true {
                    self.tagsArray = []
                    self.showAlert("There are no available tags")
                } else {
                    self.tagsArray = response!.availableTags() as! [String]
                    self.showAlert(String(describing: self.tagsArray))
                    print("Tags response: \(response)")
                }
            } else {
                self.showAlert("Error \(error?.localizedDescription)")
                print("Error \(error?.localizedDescription)")
            }
            
        }
//        MFPPush.sharedInstance().getTags({(response: WLResponse!, error: NSError!) -> Void in
//            if error == nil {
//                print("The response is: \(response)")
//                print("The response text is \(response.responseText)")
//                if response.availableTags().isEmpty == true {
//                    self.tagsArray = []
//                    self.showAlert("There are no available tags")
//                } else {
//                    self.tagsArray = response.availableTags()
//                    self.showAlert(String(self.tagsArray))
//                    print("Tags response: \(response)")
//                }
//            } else {
//                self.showAlert("Error \(error.description)")
//                print("Error \(error.description)")
//            }
//            
//        })
    }
    
    @IBAction func subscribe(_ sender: AnyObject) {
        print("Subscribe entered")
        
        // Subscribe to tags
        MFPPush.sharedInstance().subscribe(self.tagsArray) { (response, error)  -> Void in
            if error == nil {
                self.showAlert("Subscribed successfully")
                print("Subscribed successfully response: \(response)")
            } else {
                self.showAlert("Failed to subscribe")
                print("Error \(error?.localizedDescription)")
            }
        }
//        MFPPush.sharedInstance().subscribe(self.tagsArray, completionHandler: {(response: WLResponse!, error: NSError!) -> Void in
//            if error == nil {
//                self.showAlert("Subscribed successfully")
//                print("Subscribed successfully response: \(response)")
//            } else {
//                self.showAlert("Failed to subscribe")
//                print("Error \(error.description)")
//            }
//        })
    }
    
    @IBAction func getSubscriptions(_ sender: AnyObject) {
        print("Get subscription entered")
        
        // Get list of subscriptions
        MFPPush.sharedInstance().getSubscriptions { (response, error) -> Void in
            if error == nil {
                
                var tags = [String]()
                
                let json = (response?.responseJSON)! as [AnyHashable: Any]
                let subscriptions = json["subscriptions"] as? [[String: AnyObject]]
                
                for tag in subscriptions! {
                    if let tagName = tag["tagName"] as? String {
                        print("tagName: \(tagName)")
                        tags.append(tagName)
                    }
                }
                
                self.showAlert(String(describing: tags))
            } else {
                self.showAlert("Error \(error?.localizedDescription)")
                print("Error \(error?.localizedDescription)")
            }
        }
//        MFPPush.sharedInstance().getSubscriptions({(response: WLResponse!, error: NSError!) -> Void in
//            if error == nil {
//
//                var tags = [String]()
//
//                let json = response.responseJSON as Dictionary
//                let subscriptions = json["subscriptions"] as? [[String: AnyObject]]
//                
//                for tag in subscriptions! {
//                    if let tagName = tag["tagName"] as? String {
//                        print("tagName: \(tagName)")
//                        tags.append(tagName)
//                    }
//                }
//                
//                self.showAlert(String(tags))
//            } else {
//                self.showAlert("Error \(error.description)")
//                print("Error \(error.description)")
//            }
//        })
    }
    
    @IBAction func unsubscribe(_ sender: AnyObject) {
        print("Unsubscribe entered")
        
        // Unsubscribe from tags
        MFPPush.sharedInstance().unsubscribe(self.tagsArray) { (response, error)  -> Void in
            if error == nil {
                self.showAlert("Unsubscribed successfully")
                print(String(describing:response?.description))
            } else {
                self.showAlert("Error \(error?.localizedDescription)")
                print("Error \(error?.localizedDescription)")
            }
        }
//        MFPPush.sharedInstance().unsubscribe(self.tagsArray, completionHandler: {(response: WLResponse!, error: NSError!) -> Void in
//            if error == nil {
//                self.showAlert("Unsubscribed successfully")
//                print(String(response.description))
//            } else {
//                self.showAlert("Error \(error.description)")
//                print("Error \(error.description)")
//            }
//        })
    }
    
    @IBAction func UnregisterDevice(_ sender: AnyObject) {
        print("Unregister device entered")
        
        // Disable buttons
        self.disableButtons()
        
        // Unregister device
        MFPPush.sharedInstance().unregisterDevice { (response, error)  -> Void in
            if error == nil {
                self.disableButtons()
                self.showAlert("Unregistered successfully")
                print("Subscribed successfully response: \(response)")
            } else {
                self.showAlert("Error \(error?.localizedDescription)")
                print("Error \(error?.localizedDescription)")
            }
        }
//        MFPPush.sharedInstance().unregisterDevice({(response: WLResponse!, error: NSError!) -> Void in
//            if error == nil {
//                self.disableButtons()
//                self.showAlert("Unregistered successfully")
//                print("Subscribed successfully response: \(response)")
//            } else {
//                self.showAlert("Error \(error.description)")
//                print("Error \(error.description)")
//            }
//        })
    }
    
}
