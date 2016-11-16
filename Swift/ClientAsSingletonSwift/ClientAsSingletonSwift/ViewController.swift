//
//  ViewController.swift
//  ClientAsSingletonSwift
//
//  Created by Jordan Zucker on 11/15/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit
import PubNub

class ViewController: UIViewController, PNObjectEventListener {
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MyPubNubClient.sharedClient.addListener(self)
        textView.text = "Loaded!\n"
        textView.isEditable = false
        textView.setNeedsLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        textView.text = "Cleared due to memory warning\n"
        textView.setNeedsLayout()
    }
    
    // MARK: - PNObjectEventListener
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        let statusString = "\(status.debugDescription)\n"
        textView.text = statusString.appending(textView.text)
        textView.setNeedsLayout()
    }
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        let messageString = "\(message.debugDescription)\n"
        textView.text = messageString.appending(textView.text)
        textView.setNeedsLayout()
    }
    
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        let presenceString = "\(event.debugDescription)\n"
        textView.text = presenceString.appending(textView.text)
        textView.setNeedsLayout()
    }


}

