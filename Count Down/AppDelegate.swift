//
//  AppDelegate.swift
//  Count Down
//
//  Created by Julia Grill on 06/01/2015.
//  Copyright (c) 2015 Julia Grill. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [UIUserNotificationType.sound, UIUserNotificationType.alert, UIUserNotificationType.badge], categories: nil))
        
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.backgroundColor = UIColor.white
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStore.SharedInstance.saveContext()
    }
}

