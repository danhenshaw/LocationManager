//
//  LocationErrorModel.swift
//  LocationManager
//
//  Created by Daniel Henshaw on 25/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

enum UserLocationError: Swift.Error {
    case canNotBeLocated
    case permissionsDenied
    case canNotGetPlace
}
