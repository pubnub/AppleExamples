//
//  Account.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/18/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit

fileprivate let AccountUUIDKey = "ActiveUserUUIDKey"
fileprivate let AccountNameKey = "ActiveUserNameKey"

class Account: NSObject {
    
    static let sharedAccount = Account()
    
    private var activeUserObserverContext = 0
    
    dynamic var activeUser: User? {
        didSet {
            UserDefaults.standard.set(activeUser?.uuid, forKey: AccountUUIDKey)
            UserDefaults.standard.set(activeUser?.name, forKey: AccountNameKey)
            oldValue?.removeObserver(self, forKeyPath: #keyPath(activeUser))
            activeUser?.addObserver(self, forKeyPath: #keyPath(User.name), options: [.new, .old], context: &activeUserObserverContext)
        }
    }
    
    var hasActiveUser: Bool {
        get {
            if let _ = activeUser {
                return true
            } else {
                return false
            }
        }
    }
    
    override init() {
        super.init()
        guard let actualUUID = UserDefaults.standard.string(forKey: AccountUUIDKey), let actualName = UserDefaults.standard.string(forKey: AccountNameKey) else {
            return
        }
        self.activeUser = User(uuid: actualUUID, name: actualName)
        activeUser?.addObserver(self, forKeyPath: #keyPath(User.name), options: [.new, .old, .initial, .prior], context: &activeUserObserverContext)
    }
    
    deinit {
        self.activeUser = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &activeUserObserverContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        guard let user = object as? User else {
            fatalError("What did we get instead? \(object.debugDescription)")
        }
        UserDefaults.standard.set(user.name, forKey: AccountNameKey)
    }
    
    func updateNameAlertController(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        var title: String
        if let _ = activeUser {
            title = "Update name"
        } else {
            title = "Choose a name"
        }
        let alertController = UIAlertController(title: title, message: "Enter a name to display to others", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter ..."
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let textField = alertController.textFields?[0] else {
                fatalError("Expected textfield")
            }
            guard let inputText = textField.text else {
                handler?(action)
                return
            }
            if let actualUser = self.activeUser {
                actualUser.name = inputText
            } else {
                self.activeUser = User(uuid: UUID().uuidString, name: inputText)
            }
            handler?(action)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: handler)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    

}
