//
//  User.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/18/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit

class User: NSObject {
    
    let uuid: String
    let name: String
    
    init(uuid: String, name: String) {
        self.uuid = uuid
        self.name = name
    }
    
}
