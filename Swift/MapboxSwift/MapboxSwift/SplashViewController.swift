//
//  SplashViewController.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/18/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logInButton.addTarget(self, action: #selector(logInButtonTapped(sender:)), for: .touchUpInside)
        navigationItem.title = "PubNub"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logInButtonTapped(sender: UIButton) {
        let logInAlertController = Account.sharedAccount.logInAlertController { (action) in
            guard action.title == "OK" else {
                return
            }
            if Account.sharedAccount.hasActiveUser {
                DispatchQueue.main.async {
                    let mapViewController = MapViewController.storyboardController()
                    let navController = UINavigationController(rootViewController: mapViewController)
                    navController.modalPresentationStyle = .fullScreen
                    navController.modalTransitionStyle = .coverVertical
                    self.present(navController, animated: true)
                }
            }
        }
        present(logInAlertController, animated: true)
    }

}
