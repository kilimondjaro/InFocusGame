//
//  AppDelegate.swift
//  InFocusGame
//
//  Created by Kirill Babich on 16/04/2018.
//  Copyright © 2018 Kirill Babich. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {                
        
        let context = CoreDataManager.instance.persistentContainer.viewContext
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore  {
            for categoryName in Categories.getCategories() {
                let category = Category(context: context)
                category.name = categoryName.rawValue
                
                for i in Constants.obejcts[categoryName]! {
                    let object = ObjectType(context: context)
                    object.name = i.key
                    object.active = true
                    object.desc = ""
                    category.addToObjects(object)
                }
            }
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            UserDefaults.standard.set(true, forKey: "trial")
            UserDefaults.standard.set(true, forKey: "voiceAssistant")
            UserDefaults.standard.set(true, forKey: "music")
            UserDefaults.standard.set(true, forKey: "onlyNames")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(true, forKey: "firstScan")
            UserDefaults.standard.set(true, forKey: "firstSearch")
            UserDefaults.standard.set(true, forKey: "firstRead")
            UserDefaults.standard.set(GameMode.library.rawValue, forKey: "gameType")
        }                
        
        return true
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }
}

