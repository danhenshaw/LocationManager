//
//  UserLocation.swift
//  LocationManager
//
//  Created by Daniel Henshaw on 25/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import CoreLocation

typealias Coordinate = CLLocationCoordinate2D

protocol UserLocation {
    var coordinate: Coordinate { get }
    
}

extension CLLocation: UserLocation { }




typealias Place = CLPlacemark

protocol Placemark {
    var placemark: Place { get }
}

extension CLPlacemark: Placemark {
    var placemark: Place {
        return self
    }
}

