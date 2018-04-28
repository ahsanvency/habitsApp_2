//
//  AppDelegate.swift
//  Habits
//
//  Created by ahsan vency on 1/1/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import UserNotifications
import SwiftKeychainWrapper


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController: UIViewController!
        
        let accessToken: String? = KeychainWrapper.standard.string(forKey: KEY_UID)
        if accessToken != nil {
            
            initialViewController = storyBoard.instantiateViewController(withIdentifier: "mainVCID") as! MainVC
        }
        else{
            let userDefaults = UserDefaults.standard
            if userDefaults.bool(forKey: "onBoardingComplete"){
                initialViewController = storyBoard.instantiateViewController(withIdentifier: "loginID") as! loginVC
            }else{
                initialViewController = storyBoard.instantiateViewController(withIdentifier: "onboardingID") as! onboardingVC
            }
            window?.makeKeyAndVisible()
        }
            window?.rootViewController = initialViewController
        
        
        //Changes the status bar to be of light content
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Makes the user notifications work
        UNUserNotificationCenter.current().delegate = self
        
        //Configures firebase
        FirebaseApp.configure()
        
        //IQKeyboardManager.sharedManager().enable = true
        
       //To connect it to facebook type this line of code
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        //Also type these lines of code, they work and its a thing
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Messaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @objc func tokenRefreshNotification(notification: NSNotification){
        let refreshedToken = InstanceID.instanceID().token()!

        connectToFirebaseMessaging()
    }
    
    func connectToFirebaseMessaging(){
        Messaging.messaging().connect{ (error) in
            if error != nil{
                print("Unable to connect \(String(describing: error))")
            }else{
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

