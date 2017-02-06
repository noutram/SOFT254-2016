//
//  AppDelegate.swift
//  BackgroundTest
//
//  Created by Nicholas Outram on 30/11/2015.
//  Copyright © 2015 Plymouth University. All rights reserved.
//

import UIKit

struct Fred {
    var a : Int = 0
    var b : Int = 99
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?


   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      // Override point for customization after application launch.
      print("\(#file), \(#function)")
    
    var c1 : Fred = Fred()
    var c2 : Fred = c1
    c1.a = c1.a + 1
    c2.b = c2.a + 1
    print("c2 = \(c2.a)")
    
      
      return true
   }

   func applicationWillResignActive(_ application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
      print("\(#file), \(#function)")
   }

   func applicationDidEnterBackground(_ application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      print("\(#file), \(#function)")
      globalModel.save() {
         print("Entering background - Saving data")
      }
   }

   func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
      print("\(#file), \(#function)")
   }

   func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      print("\(#file), \(#function)")
   }

   func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      print("\(#file), \(#function)")
      globalModel.save() {
         print("Application Terminating - Saving data")
      }
   }


}

