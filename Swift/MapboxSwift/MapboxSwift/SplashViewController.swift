//
//  SplashViewController.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/18/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var setUsernameButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUsernameButton.addTarget(self, action: #selector(setUsernameButtonTapped(sender:)), for: .touchUpInside)
        navigationItem.title = "PubNub"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUsernameButtonTapped(sender: UIButton) {
        let usernameAlertController = Account.sharedAccount.updateNameAlertController { (action) in
            guard action.title == "OK" else {
                return
            }
            if Account.sharedAccount.hasActiveUser {
                DispatchQueue.main.async {
                    let mapViewController = MapViewController.storyboardController()
                    self.navigationController?.pushViewController(mapViewController, animated: true)
                }
            }
        }
        present(usernameAlertController, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
