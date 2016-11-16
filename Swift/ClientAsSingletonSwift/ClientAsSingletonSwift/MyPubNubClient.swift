//
//  MyPubNubClient.swift
//  ClientAsSingletonSwift
//
//  Created by Jordan Zucker on 11/15/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit
import PubNub

fileprivate let publishKey = "demo"
fileprivate let subscribeKey = "demo"

class MyPubNubClient: PubNub, PNObjectEventListener {
    
    static let sharedClient: MyPubNubClient = {
        let config = PNConfiguration(publishKey: publishKey, subscribeKey: subscribeKey)
        let client = MyPubNubClient.clientWithConfiguration(config)
        client.addListener(client) // This is so we can handle status updates below
        return client
    }()
    
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
