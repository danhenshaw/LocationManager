//
//  LocationManagerTests.swift
//  LocationManagerTests
//
//  Created by Daniel Henshaw on 25/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import XCTest
import CoreLocation
import Intents
import Contacts
@testable import LocationManager

class LocationViewControllerTests: XCTestCase {
    
    var sut: LocationViewController!
    var locationProvider: UserLocationProviderMock!
    
    override func setUp() {
        super.setUp()
        locationProvider = UserLocationProviderMock()
        sut = LocationViewController(locationProvider: locationProvider)
    }
    
    override func tearDown() {
        sut = nil
        locationProvider = nil
        super.tearDown()
    }
    
    func testRequestUserLocation_Nil() {
        locationProvider.location = Response.error(.canNotBeLocated)
        sut.requestUserLocation()
        XCTAssertNil(sut.userLocation)
    }
    
    func testRequestUserLocation_NotNil() {
        locationProvider.location = Response.success(UserLocationMock())
        sut.requestUserLocation()
        XCTAssertNotNil(sut.userLocation)
    }
    
    func testGeocoder_Nil() {
        locationProvider.place = Response.error(.canNotGetPlace)
        sut.getPlace(for: UserLocationMock())
        XCTAssertNil(sut.userPlace)
    }
    
    func testGeocoder_NotNil() {
        locationProvider.place = Response.success(PlacemarkMock())
        sut.getPlace(for: UserLocationMock())
        XCTAssertNotNil(sut.userPlace)
    }
    
    
    
    
}


// MARK: - User location mock

struct UserLocationMock: UserLocation {
    var coordinate: Coordinate {
        return Coordinate(latitude: 52.5200, longitude: 13.4050)
    }
}


// MARK: - User placemark mock

struct PlacemarkMock: Placemark {
    
    var placemark: Place {
        let location = CLLocation(latitude: 52.5200, longitude: 13.4050)
        let mockPlacemark = Place(placemark: CLPlacemark(location: location, name: "MockName", postalAddress: nil))
        return Place(placemark: mockPlacemark)
    }
    
}


// MARK: - User location provider mock

class UserLocationProviderMock: UserLocationProvider {
    
    var location: Response<UserLocation>?
    var place: Response<Placemark>?

    func findUserLocation(completion: @escaping UserLocationCompletionBlock) {
        if let location = location {
            completion(location)
        }
    }
    
    func getPlace(for location: Coordinate, completion: @escaping PlaceCompletionBlock) {
        if let place = place {
            completion(place)
        }
    }
}
