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

fileprivate let publishKey = "demo"
fileprivate let subscribeKey = "demo"

let LocationActivityChannel = "LocationActivityChannel"

class Network: NSObject, PNObjectEventListener {
    
    private var activeUserObserverContext = 0
    
    
    static let sharedNetwork: Network = {
        let config = PNConfiguration(publishKey: publishKey, subscribeKey: subscribeKey)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("How did we not find the app delegate?")
        }
        let client = PubNub.clientWithConfiguration(config, callbackQueue: appDelegate.dispatchQueue)
        return Network(client: client, dispatchQueue: appDelegate.dispatchQueue)
    }()
    
    public private(set) var client: PubNub? {
        willSet {
            client?.removeListener(self)
        }
        didSet {
            client?.addListener(self)
        }
    }
    
    private let configuration: PNConfiguration = {
        let config = PNConfiguration(publishKey: publishKey, subscribeKey: subscribeKey)
        return config
    }()
    
    let dispatchQueue: DispatchQueue
    
    init(client: PubNub? = nil, dispatchQueue: DispatchQueue) {
        self.client = client
        self.dispatchQueue = dispatchQueue
        super.init()
        self.client?.addListener(self)
    }
    
    var uuid: String? {
        get {
            return client?.uuid()
        }
        set {
            guard let actualUUID = newValue else {
                client?.unsubscribeFromAll()
                // warning this must be thread-safe (it isn't now)
                client = nil
                return
            }
            configuration.uuid = actualUUID
            guard let existingClient = client else {
                client = PubNub.clientWithConfiguration(configuration, callbackQueue: self.dispatchQueue)
                return
            }
            existingClient.copyWithConfiguration(configuration, callbackQueue: self.dispatchQueue, completion: { (copiedClient) in
                self.client = copiedClient
                
            })
            
        }
    }
    
    // MARK: - PubNub Actions
    
    func publish(location: CLLocationCoordinate2D, for user: User) {
        let message: [String: Any] = [
            "username": user.name,
            "uuid": user.uuid,
            "latitude": location.latitude,
            "longitude": location.longitude,
        ]
        client?.publish(message, toChannel: LocationActivityChannel, withCompletion: { (status) in
            if status.isError {
                print("Handle publish error")
            }
        })
    }
    
    func publishActiveUserLocation(location: CLLocationCoordinate2D) {
        guard let activeUser = Account.sharedAccount.activeUser else {
            return
        }
        publish(location: location, for: activeUser)
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
