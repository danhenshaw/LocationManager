//
//  UserLocationServices.swift
//  LocationManager
//
//  Created by Daniel Henshaw on 25/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import CoreLocation

class UserLocationService: NSObject, UserLocationProvider {
    
    fileprivate var provider : LocationProvider
    fileprivate var locationCompletionBlock: UserLocationCompletionBlock?
    fileprivate var placeComplationBlock: PlaceCompletionBlock?
    
    init(with provider: LocationProvider) {
        self.provider = provider
        super.init()
    }
    
    func findUserLocation(completion: @escaping UserLocationCompletionBlock) {
        self.locationCompletionBlock = completion
        provider.requestLocation()
    }
    
    func getPlace(for location: Coordinate, completion: @escaping PlaceCompletionBlock) {
        self.placeComplationBlock = completion
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(Response.error(.canNotGetPlace))
                return
            }
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(Response.error(.canNotGetPlace))
                return
            }
            completion(Response.success(placemark))
        }
    }
}


extension UserLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: provider.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways: provider.requestLocation()
        case .restricted, .denied: locationCompletionBlock?(Response.error(.permissionsDenied))
        default: print("locationManager unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let location = locations.last {
            locationCompletionBlock?(Response.success(location))
        } else {
            locationCompletionBlock?(Response.error(.canNotBeLocated))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        locationCompletionBlock?(Response.error(.canNotBeLocated))
    }
}
