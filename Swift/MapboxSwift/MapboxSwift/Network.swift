//
//  Network.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/18/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit
import PubNub

fileprivate let publishKey = "demo"
fileprivate let subscribeKey = "demo"

class Network: NSObject, PNObjectEventListener {
    
    private var activeUserObserverContext = 0
    
    static let sharedNetwork: Network = {
        let config = PNConfiguration(publishKey: publishKey, subscribeKey: subscribeKey)
        let client = PubNub.clientWithConfiguration(config)
        return Network(client: client)
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
    
    init(client: PubNub? = nil) {
        self.client = client
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
                client = PubNub.clientWithConfiguration(configuration)
                return
            }
            existingClient.copyWithConfiguration(configuration, completion: { (copiedClient) in
                self.client = copiedClient
            })
            
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
