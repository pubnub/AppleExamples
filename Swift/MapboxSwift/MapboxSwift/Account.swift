//
//  Account.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/18/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit
import CoreData

fileprivate let AccountUUIDKey = "ActiveUserUUIDKey"
fileprivate let AccountNameKey = "ActiveUserNameKey"

extension NSNotification.Name {
    public static let LogInNotification = NSNotification.Name("LogInNotification")
    public static let LogOutNotification = NSNotification.Name("LogOutNotification")
}

class Account: NSObject {
    
    static let sharedAccount = Account()
    
    var dataController: DataController?
    
    private var _activeUserObjectID: NSManagedObjectID? {
        didSet {
            var userNotificationName: Notification.Name
            if let _ = _activeUserObjectID {
                userNotificationName = .LogInNotification
            } else {
                userNotificationName = .LogOutNotification
            }
            NotificationCenter.default.post(name: userNotificationName, object: nil)
        }
    }
    
    var activeUserObjectID: NSManagedObjectID? {
        get {
            var currentID: NSManagedObjectID? = nil
            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext]) {
                currentID = self._activeUserObjectID
            }
            dispatchQueue.sync(execute: dispatchWorkItem)
            return currentID
        }
//        set {
//            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext, .barrier]) {
//                self._activeUserObjectID = newValue
//                
//            }
//            dispatchQueue.async(execute: dispatchWorkItem)
//        }
    }
    
//    private dynamic var _activeUserUUID: String?
//    
//    private dynamic var activeUserUUID: String? {
//        get {
//            var currentUUID: String? = nil
//            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext]) {
//                currentUUID = self._activeUserUUID
//            }
//            dispatchQueue.sync(execute: dispatchWorkItem)
//            return currentUUID
//        }
//        set {
//            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext, .barrier]) {
//                
//            }
//            dispatchQueue.async(execute: dispatchWorkItem)
//        }
//    }
//    
//    private var _activeUser: User?
//    
//    dynamic var activeUser: User? {
//        get {
//            var currentUser: User? = nil
//            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext]) {
//                currentUser = self._activeUser
//            }
//            dispatchQueue.sync(execute: dispatchWorkItem)
//            return currentUser
//        }
//        set {
//            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext, .barrier]) {
//                
//            }
//            dispatchQueue.async(execute: dispatchWorkItem)
//        }
//    }
    
//    private dynamic var _activeUserUUID: String? = UserDefaults.standard.string(forKey: AccountUUIDKey)
//    private var _activeUser: User? = nil
//    
//    private dynamic var activerUserUUID: String? {
//        get {
//            var currentUserUUID: String? = nil
//            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext]) {
//                currentUserUUID = self._activeUserUUID
//            }
//            dispatchQueue.sync(execute: dispatchWorkItem)
//            return currentUserUUID
//        }
//        set {
//            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext, .barrier]) {
//                print(#function)
//                self.willChangeValue(forKey: #keyPath(Account.activerUserUUID))
//                self._activeUserUUID = newValue
//                self.didChangeValue(forKey: #keyPath(Account.activerUserUUID))
//                Network.sharedNetwork.uuid = self._activeUserUUID
//                UserDefaults.standard.set(self._activeUserUUID, forKey: AccountUUIDKey)
//                var userNotificationName: Notification.Name
//                if let actualUUID = self._activeUserUUID {
//                    self.dataController = DataController(uuid: actualUUID)
//                    self.dataController?.persistentContainer.performBackgroundTask({ (context) in
//                        self.activeUser = User.createOrFetch(user: actualUUID, in: context)
//                    })
//                    self.dataController?.saveContext()
//                    userNotificationName = .LogInNotification
//                    
//                } else {
//                    userNotificationName = .LogOutNotification
//                    self.dataController?.saveContext()
//                    self.activeUser = nil
//                    self.dataController = nil
//                }
//                NotificationCenter.default.post(name: userNotificationName, object: nil)
//            }
//            dispatchQueue.async(execute: dispatchWorkItem)
//        }
//
//    }
//    
//    var activeUser: User? {
//        get {
//            var currentUser: User? = nil
//            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext]) {
//                currentUser = self._activeUser
//            }
//            dispatchQueue.sync(execute: dispatchWorkItem)
//            return currentUser
//        }
//        // Only set inside a barrier block
//        set {
//            self._activeUser = newValue
//        }
//    }
    
//    private var activeUserObserverContext = 0
    
//    private dynamic var _activeUser: User? = nil
    
//    dynamic var activeUser: User? {
//        get {
//            var currentUser: User? = nil
//            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext]) {
//                currentUser = self._activeUser
//            }
//            dispatchQueue.sync(execute: dispatchWorkItem)
//            return currentUser
//        }
//        set {
//            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext, .barrier]) {
//                print(#function)
//                self.willChangeValue(forKey: #keyPath(Account.activeUser))
//                self._activeUser = newValue
//                self.didChangeValue(forKey: #keyPath(Account.activeUser))
//                Network.sharedNetwork.uuid = self._activeUser?.uuid
//                UserDefaults.standard.set(self._activeUser?.uuid, forKey: AccountUUIDKey)
//                UserDefaults.standard.set(self._activeUser?.name, forKey: AccountNameKey)
//                var userNotificationName: Notification.Name
//                if let _ = self._activeUser {
//                    userNotificationName = .LogInNotification
//                } else {
//                    userNotificationName = .LogOutNotification
//                }
//                NotificationCenter.default.post(name: userNotificationName, object: nil)
//            }
//            dispatchQueue.async(execute: dispatchWorkItem)
//        }
//        didSet {
//            UserDefaults.standard.set(activeUser?.uuid, forKey: AccountUUIDKey)
//            UserDefaults.standard.set(activeUser?.name, forKey: AccountNameKey)
//            var userNotificationName: Notification.Name
//            if let _ = activeUser {
//                userNotificationName = .LogInNotification
//            } else {
//                userNotificationName = .LogOutNotification
//            }
//            NotificationCenter.default.post(name: userNotificationName, object: nil)
////            oldValue?.removeObserver(self, forKeyPath: #keyPath(activeUser))
////            activeUser?.addObserver(self, forKeyPath: #keyPath(User.name), options: [.new, .old], context: &activeUserObserverContext)
//        }
//    }
    
    
    var hasActiveUser: Bool {
        get {
            if let _ = activeUserObjectID {
                print("what what true")
                return true
            } else {
                print("what what false")
                return false
            }
        }
    }
    
    let dispatchQueue: DispatchQueue
    
    override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("How did we not find the app delegate?")
        }
        self.dispatchQueue = appDelegate.dispatchQueue
        super.init()
        let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext, .barrier]) {
            guard let actualUUID = UserDefaults.standard.string(forKey: AccountUUIDKey) else {
                return
            }
            self.dataController = DataController(uuid: actualUUID)
            self.dataController?.persistentContainer.performBackgroundTask({ (context) in
                guard let user = User.fetch(user: actualUUID, in: context) else {
                    fatalError("Should have found user")
                }
                self._activeUserObjectID = user.objectID
            })
        }
        dispatchQueue.async(execute: dispatchWorkItem)
        
////        dataController = DataController(uuid: actualUUID)
//        self.activerUserUUID = actualUUID
//        self.activeUser = User(uuid: actualUUID, name: actualName)
        //activeUser?.addObserver(self, forKeyPath: #keyPath(User.name), options: [.new, .old, .initial, .prior], context: &activeUserObserverContext)
    }
    
    /*
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
 */
    
    func logInAlertController(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: "Login", message: "Enter a name to log in", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Full name ..."
        }
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let textField = alertController.textFields?[0] else {
                fatalError("Expected textfield")
            }
            guard let inputText = textField.text else {
                handler?(action)
                return
            }
            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext, .barrier]) {
                let uuid = UUID().uuidString
                self.dataController = DataController(uuid: uuid)
                self.dataController?.persistentContainer.performBackgroundTask({ (context) in
                    context.performAndWait {
                        let user = User(context: context)
                        user.uuid = uuid
                        user.name = inputText
                        do {
                            try context.save()
                        } catch {
                            fatalError(error.localizedDescription)
                        }
                    }
                })
                UserDefaults.standard.set(uuid, forKey: AccountUUIDKey)
            }
            self.dispatchQueue.async(execute: dispatchWorkItem)
            let handlerDispatchItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext, .barrier]) {
                handler?(action)
            }
            self.dispatchQueue.async(execute: handlerDispatchItem)
//            self.activerUserUUID = UUID().uuidString
//            self.dataController?.persistentContainer.performBackgroundTask({ (context) in
//                self.activeUser?.name = inputText
//                self.dataController?.saveContext()
//            })
//            self.activeUser = User(uuid: UUID().uuidString, name: inputText)
            
//            handler?(action)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: handler)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func logOutAlertController(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log Out", style: .default, handler: { (action) in
//            self.activeUser = nil
            // Is this even necessary?
//            self.activerUserUUID = nil
            let dispatchWorkItem = DispatchWorkItem(qos: .userInitiated, flags: [.assignCurrentContext, .barrier]) {
                self.dataController?.saveContext()
                self.dataController = nil
                self._activeUserObjectID = nil
                UserDefaults.standard.set(nil, forKey: AccountUUIDKey)
            }
            self.dispatchQueue.async(execute: dispatchWorkItem)
            self.dispatchQueue.async(execute: {
                handler?(action)
            })
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: handler)
        
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    /*
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
    */

}
