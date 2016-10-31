//
//  AppDelegate.swift
//  ClientInAppDelegateSwift
//
//  Created by Jordan Zucker on 10/28/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit
import PubNub

fileprivate let publishKey = "demo"
fileprivate let subscribeKey = "demo"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {

    var window: UIWindow?
    
    lazy var client: PubNub = {
        // insert your keys here
        let config = PNConfiguration(publishKey: publishKey, subscribeKey: subscribeKey)
        let createdClient = PubNub.clientWithConfiguration(config)
        // optionally add the app delegate as a listener, or anything else
        // View Controllers should get the client from the App Delegate
        // and add themselves as listeners if they are interested in
        // stream events (subscribe, presence, status)
        createdClient.addListener(self)
        return createdClient
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
        self.client.unsubscribeFromAll()
        // optionally add any push notification channels here
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // This is the best place to begin resubscribing to any important channels
        let channels = [
            "a",
        ]
        self.client.subscribeToChannels(channels, withPresence: true)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Memory Warning
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        // This is called when there is memory pressure, as expected
        // It is a good to release our reference to our PubNub client if
        // it is not subscribing, since it is needed then, and will be
        // created again if it is needed.
        // Note: Only release it if it is not subscribing, otherwise this
        // will most likely negatively impact user experience
        if self.client.channels().isEmpty && self.client.channelGroups().isEmpty && self.client.presenceChannels().isEmpty {
            self.client = nil
        }
    }
    
    // MARK: - PNObjectEventListener
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        // This is a good place to deal with unexpected status messages like
        // network failures
    }
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        // This most likely won't be used here, but in any relevant view controllers
    }
    
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        // This most likely won't be used here, but in any relevant view controllers
    }


}

