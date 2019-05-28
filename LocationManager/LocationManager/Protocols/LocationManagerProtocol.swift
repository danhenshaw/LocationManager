//
//  UserLocationProvider.swift
//  LocationManager
//
//  Created by Daniel Henshaw on 25/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

enum Response<Value> {
    case success(Value)
    case error(UserLocationError)
}

typealias UserLocationCompletionBlock = (Response<UserLocation>) -> Void
typealias PlaceCompletionBlock = (Response<Placemark>) -> Void

protocol UserLocationProvider {
    func findUserLocation(completion: @escaping UserLocationCompletionBlock)
    func getPlace(for location: Coordinate, completion: @escaping PlaceCompletionBlock)
}
