//
//  ViewController.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/16/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit
import Mapbox

fileprivate let UsernameKey = "UsernameKey"

class ViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    var username: String? {
        didSet {
            UserDefaults.standard.set(username, forKey: UsernameKey)
            navigationItem.title = username ?? "Choose username"
        }
    }
    
    var userLocations: [String:CLLocationCoordinate2D] = [String:CLLocationCoordinate2D]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        username = UserDefaults.standard.string(forKey: UsernameKey)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Username", style: .plain, target: self, action: #selector(setUsernameButtonTapped(sender:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if username == nil {
            let alertController = usernameAlertController()
            present(alertController, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Username
    
    func usernameAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "Enter username", message: "Choose a name to display to others on your map", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Username ..."
        })
        let setAction = UIAlertAction(title: "Set username", style: .default, handler: { (action) in
            guard let textField = alertController.textFields?[0] else {
                fatalError("Expected textfield")
            }
            self.username = textField.text
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(setAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    func setUsernameButtonTapped(sender: UIBarButtonItem) {
        let alertController = usernameAlertController()
        present(alertController, animated: true)
    }
    
    // MARK: - MGLMapViewDelegate


}

