//
//  MapViewController.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/18/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    static func storyboardController() -> MapViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
//        guard let userName = Account.sharedAccount.activeUser?.name else {
//            dismiss(animated: true)
//            return
//        }
//        navigationItem.title = userName
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(logOutButtonTapped(sender:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped(sender:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UINavigation Actions
    
    func logOutButtonTapped(sender: UIBarButtonItem) {
        let logOutController = Account.sharedAccount.logOutAlertController { (action) in
            guard action.title == "Log Out" else {
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
        present(logOutController, animated: true)
    }
    
    func refreshButtonTapped(sender: UIBarButtonItem) {
        
    }
    

}
