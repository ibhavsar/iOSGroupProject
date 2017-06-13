//
//  AppDelegate.swift
//  iOSGroupProject
//
//  Created by Student on 2017-03-31.
//  Copyright © 2017 Ishan Student. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    

    var window: UIWindow?
/*Local Notifications App Delegate stuff
 
 
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
 return true
 }
 
 func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
 NotificationCenter.default.post(name: Notification.Name(rawValue: "TodoListShouldRefresh"), object: self)
 }
 
 func applicationDidBecomeActive(_ application: UIApplication) {
 NotificationCenter.default.post(name: Notification.Name(rawValue: "TodoListShouldRefresh"), object: self)
 }
 
 
 
 */


    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TodoListShouldRefresh"), object: self)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TodoListShouldRefresh"), object: self)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

