//
//  LocationManager.swift
//  MapboxSwift
//
//  Created by Jordan Zucker on 11/17/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    
    static var sharedManager = LocationManager()
    
    override init() {
        super.init()
        delegate = self
        if #available(iOS 9.0, *) {
            allowsBackgroundLocationUpdates = true
        }
        distanceFilter = 2
        desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Actions
    
    func performAppStartActions() {
        switch LocationManager.authorizationStatus() {
        case .authorizedAlways:
            if Account.sharedAccount.hasActiveUser {
                startUpdatingLocation()
            }
        case .authorizedWhenInUse, .denied, .restricted:
            fatalError("Not designed to run in these conditions")
        case .notDetermined:
            requestAlwaysAuthorization()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedAlways else {
            if (status == .notDetermined) {
                return
            }
            fatalError("Status must be authorized always")
        }
        startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else {
            return
        }
        
        Network.sharedNetwork.client?.publish(<#T##message: Any##Any#>, toChannel: <#T##String#>, withCompletion: <#T##PNPublishCompletionBlock?##PNPublishCompletionBlock?##(PNPublishStatus) -> Void#>)
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let time = "\(Date())"
//        print("\(appDelegate) \(time)")
//        appDelegate.publishCurrentLocationInfo(with: latestLocation.coordinate)
        /*
         appDelegate.client.publish("\(time)", toChannel: "Background") { (status) in
         print(status.debugDescription)
         }
         */
    }

}
