//
//  Network.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/18/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit
import PubNub
import CoreLocation

fileprivate let publishKey = "demo-36"
fileprivate let subscribeKey = "demo-36"

let LocationActivityChannel = "LocationActivityChannel"

class Network: NSObject, PNObjectEventListener {
    
    private var activeUserObserverContext = 0
    
    
    static let sharedNetwork: Network = {
        let config = PNConfiguration(publishKey: publishKey, subscribeKey: subscribeKey)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("How did we not find the app delegate?")
        }
        if let activeUUID = Account.sharedAccount.activeUser?.uuid {
            config.uuid = activeUUID
        }
//        let client = PubNub.clientWithConfiguration(config, callbackQueue: appDelegate.dispatchQueue)
//        return Network(client: client, dispatchQueue: appDelegate.dispatchQueue)
        return Network(configuration: config, dispatchQueue: appDelegate.dispatchQueue)
    }()
    
    public private(set) var client: PubNub {
        willSet {
            client.removeListener(self)
        }
        didSet {
            client.addListener(self)
            subscribeToLocationActivityChannel()
        }
    }
    
    private let configuration: PNConfiguration
    
    let dispatchQueue: DispatchQueue
    
    init(configuration: PNConfiguration, dispatchQueue: DispatchQueue) {
        self.dispatchQueue = dispatchQueue
        self.configuration = configuration
        self.client = PubNub.clientWithConfiguration(configuration, callbackQueue: dispatchQueue)
        super.init()
        
        
        
        client.addListener(self)
        //self.client?.addListener(self)
    }
    
    private var _isLoggingOut = false
    
    var isLoggingOut: Bool {
        get {
            var loggingOut = false
            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext], block: {
                loggingOut = self._isLoggingOut
            })
            self.dispatchQueue.sync(execute: dispatchWorkItem)
            return loggingOut
        }
        set {
            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext, .barrier], block: {
                self._isLoggingOut = newValue
            })
            self.dispatchQueue.async(execute: dispatchWorkItem)
        }
    }
    
    var uuid: String? {
        get {
            return configuration.uuid
        }
        set {
            guard let actualUUID = newValue else {
                client.unsubscribeFromAll()
                return
            }
            configuration.uuid = actualUUID
            client.copyWithConfiguration(configuration, callbackQueue: dispatchQueue) { (copiedClient) in
                self.client = copiedClient
            }
        }
    }
    
//    var uuid: String? {
//        get {
//            return client?.uuid()
//        }
//        set {
//            guard let actualUUID = newValue else {
//                client?.unsubscribeFromAll()
//                // warning this must be thread-safe (it isn't now)
//                client = nil
//                return
//            }
//            configuration.uuid = actualUUID
//            guard let existingClient = client else {
//                client = PubNub.clientWithConfiguration(configuration, callbackQueue: self.dispatchQueue)
//                subscribeToLocationActivityChannel()
//                return
//            }
//            existingClient.copyWithConfiguration(configuration, callbackQueue: self.dispatchQueue, completion: { (copiedClient) in
//                self.client = copiedClient
//                
//            })
//            
//        }
//    }
    
    // MARK: - PubNub Actions
    
    func publish(location: CLLocationCoordinate2D, for user: User) {
        let message: [String: Any] = [
            "username": user.name,
            "uuid": user.uuid,
            "latitude": location.latitude,
            "longitude": location.longitude,
        ]
        client.publish(message, toChannel: LocationActivityChannel, withCompletion: { (status) in
            if status.isError {
                print("Publish error: \(status.debugDescription)")
            }
        })
    }
    
    func publishActiveUserLocation(location: CLLocationCoordinate2D) {
        guard let activeUser = Account.sharedAccount.activeUser else {
            return
        }
        publish(location: location, for: activeUser)
    }
    
    func subscribeToLocationActivityChannel() {
        client.subscribeToChannels([LocationActivityChannel], withPresence: true)
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
