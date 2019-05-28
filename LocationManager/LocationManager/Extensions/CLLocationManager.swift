//
//  LocationProvider.swift
//  LocationManager
//
//  Created by Daniel Henshaw on 25/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import CoreLocation

protocol LocationProvider {
    var isUserAuthorized: Bool { get }
    func requestWhenInUseAuthorization()
    func requestLocation()
}

extension CLLocationManager: LocationProvider {
    
    var isUserAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
}
