//
//  AppDelegate.swift
//  ElevenChat
//
//  Created by Cameron Dershem on 9/10/14.
//  Copyright (c) 2014 Cameron Dershem. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // setup dropbox
        let dbSession = DBSession(appKey: "ty5kixasdbgkv8x", appSecret: "22cisqicel37gme", root: kDBRootAppFolder)
        
        DBSession.setSharedSession(dbSession)
        
        // set up parse for testing
//        Parse.setApplicationId("biYrAsTEvW7bnVjcruzax7Nqqb8la2oD5GzoEyG2", clientKey: "JhRbQfHK90qVbefxPPsjuKltt3rD3bjwF5MOpkAp")
        
        // elevenfifty for realzies
        Parse.setApplicationId("T1cb1yFelU8TAZYqHFk1JMBc0hunnb4ePOOJuSb5", clientKey: "ssdWbqBmUXhIOmvxi6lZnJfnGfIXnPea5sK2ic2Z")
        
//        var testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackground()
        
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        // handle dropbox urls
        if DBSession.sharedSession().handleOpenURL(url) {
            if DBSession.sharedSession().isLinked() {
                println("Dropbox be linked!!!!")
            }
            return true
        }
        return false
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


}

