//
//  AppDelegate.swift
//  LocationManager
//
//  Created by Daniel Henshaw on 25/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate weak var navigationController: NavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let location = CLLocationManager()
        let locationProvider = UserLocationService(with: location)
        let viewController = LocationViewController(locationProvider: locationProvider)
        location.delegate = locationProvider
        let navigationController = NavigationController(rootViewController: viewController)
        self.navigationController = navigationController
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    


}

