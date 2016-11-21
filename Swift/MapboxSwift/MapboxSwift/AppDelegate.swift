//
//  AppDelegate.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/16/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit
import PubNub
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {
    
    var window: UIWindow?
    
    let dispatchQueue: DispatchQueue = {
        return DispatchQueue(label: "WorkQueue", qos: .default, attributes: [.concurrent])
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        LocationManager.sharedManager.performAppStartActions()
        LocationManager.sharedManager.performAppStartActions()
        if Account.sharedAccount.hasActiveUser {
            DispatchQueue.main.async {
                let mapViewController = MapViewController.storyboardController()
                let navController = UINavigationController(rootViewController: mapViewController)
                navController.modalPresentationStyle = .fullScreen
                navController.modalTransitionStyle = .coverVertical
                self.window?.rootViewController?.present(navController, animated: true)
            }
        }
        
//        if Account.sharedAccount.hasActiveUser {
//            DispatchQueue.main.async {
//                let mapViewController = MapViewController.storyboardController()
//                guard let navController = self.window?.rootViewController as? UINavigationController else {
//                    fatalError("This project is not set up as expected")
//                }
//                navController.pushViewController(mapViewController, animated: true)
//            }
//        } else {
//            DispatchQueue.main.async {
//                let alertController = Account.sharedAccount.updateNameAlertController(handler: { (action) in
//                    guard action.title == "OK" else {
//                        return
//                    }
//                    if Account.sharedAccount.hasActiveUser {
//                        DispatchQueue.main.async {
//                            let mapViewController = MapViewController.storyboardController()
//                            self.window?.rootViewController?.navigationController?.pushViewController(mapViewController, animated: true)
//                        }
//                    }
//                })
//                self.window?.rootViewController?.present(alertController, animated: true)
//            }
//        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // This is where you should unsubscribe
//        self.client.unsubscribeFromAll()
        // optionally add any push notification channels here
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // This is the best place to begin resubscribing to any important channels
//        let channels = [
//            "a",
//            ]
//        self.client.subscribeToChannels(channels, withPresence: true)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - PubNub Publish Action
    
//    func publishCurrentLocationInfo(with username: String?, location: CLLocationCoordinate2D) {
//        guard let currentUsername = username else {
//            print("We need a username to publish")
//            return
//        }
//        let message: [String: Any] = [
//            "latitude": location.latitude,
//            "longitude": location.longitude,
//            "username": currentUsername,
//            "uuid": client.uuid(),
//        ]
//        client.publish(message, toChannel: "locationChannel") { (status) in
//            if status.isError {
//                // Handle error
//            }
//        }
//        
//    }
    
}

