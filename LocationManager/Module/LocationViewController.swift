//
//  LocationViewController.swift
//  LocationManager
//
//  Created by Daniel Henshaw on 25/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {
    
    // MARK: - Properties
    
    var locationProvider: UserLocationProvider?
    
    // Variable to storeurrent location as Coordinates
    var userLocation: UserLocation?
    
    // Variable to store current location as placemark
    var userPlace: Placemark?
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var locationView: LocationView { return self.view as! LocationView }
    
    // MARK: - Constants
    
    struct Constants {
        static let cellId = "CellId"
        static let headerId = "HeaderId"
    }
    
    
    // MARK: - Life cycle
    
    init(locationProvider: UserLocationProvider) {
        self.locationProvider = locationProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        searchCompleter.delegate = self
        locationView.searchBar.delegate = self
        locationView.tableView.delegate = self
        locationView.tableView.dataSource = self
        locationView.mapView.delegate = self
        locationView.segmentedController.addTarget(self, action: #selector(segmentedControlValueDidChange(_:)), for: .valueChanged)
    }
    
    override func loadView() {
        view = LocationView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationView.searchBar.becomeFirstResponder()
    }
    
    
    // MARK: - Helpers
    
    func setupNavBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.locationView.tableView.reloadData()
            if self.searchResults.count == 0 {
                self.locationView.tableView.separatorStyle = .none
            } else {
                self.locationView.tableView.separatorStyle = .singleLine
            }
        }
    }
    
    
    // MARK: - Location helpers
    
    @objc func requestUserLocation() {
        userLocation = nil
        locationProvider?.findUserLocation { [weak self] locationResult in
            switch locationResult {
            case .error(let error):
                switch error {
                case .canNotBeLocated: print("Error fetching location")
                case .permissionsDenied: print("User has denied location permissions")
                default: print("Unknown error when fetching location: \(error)")
                }
                
            case .success(let location):
                self?.userLocation = location
                print("Location found: \(location)")
                self?.getPlace(for: location)
            }
        }
    }
    
    func getPlace(for location: UserLocation) {
        locationProvider?.getPlace(for: location.coordinate) { [weak self] placeResult in
            switch placeResult {
            case .error(let error):
                switch error {
                case .canNotGetPlace: print("Error fetching place")
                default: print("Unknown error when fetching place: \(error)")
                }
                
            case .success(let place):
                self?.userPlace = place
                self?.title = (place.placemark.locality ?? "") + ", " + (place.placemark.country ?? "")
                self?.locationView.addAnnotation(at: location.coordinate, for: place)
                self?.locationView.setMapCentrePoint(for: location.coordinate)
                print("Success! Place received: \(place)")
            }
        }
    }
    
    
    // MARK: - Actions
    
    @objc func segmentedControlValueDidChange(_ sender: UISegmentedControl) {
        searchResults.removeAll()
        switch sender.selectedSegmentIndex {
        case 0:
            locationView.showMap(false, hideSearchBar: false)
            
        case 1:
            locationView.showMap(true, hideSearchBar: true)
            if let location = userLocation?.coordinate, let place = userPlace {
                locationView.addAnnotation(at: location, for: place)
                locationView.setMapCentrePoint(for: location)
            } else {
                requestUserLocation()
            }
            
        default: print("Error! Unrecognised segmented control index selected")
        }
    }
}


// MARK: - UITableViewDelegate and UITableViewDataSource

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: Constants.cellId)
        cell.textLabel?.text = searchResults[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResults.indices.contains(indexPath.row) {
            let searchRequest = MKLocalSearch.Request(completion: searchResults[0])
            let search = MKLocalSearch(request: searchRequest)
            search.start { [weak self] (response, error) in
                let latitude = response?.mapItems[0].placemark.coordinate.latitude ?? 0
                let longitude = response?.mapItems[0].placemark.coordinate.longitude ?? 0
                let location = Coordinate(latitude: latitude, longitude: longitude)
                if let place = response?.mapItems[0].placemark {
                    self?.locationView.showMap(true, hideSearchBar: false)
                    self?.locationView.addAnnotation(at: location, for: place)
                    self?.locationView.setMapCentrePoint(for: location)
                }
            }
        }
    }
    
}


// MARK: - MKLocalSearchCompleterDelegate

extension LocationViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults.removeAll()
        let digitsCharacterSet = NSCharacterSet.decimalDigits
        let filteredResults = searchCompleter.results.filter( { $0.title.rangeOfCharacter(from: digitsCharacterSet) == nil && $0.subtitle.rangeOfCharacter(from: digitsCharacterSet) == nil})
        searchResults = filteredResults
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}


// MARK: - MKMapViewDelegate

extension LocationViewController: MKMapViewDelegate { }


// MARK: - UISearchBarDelegate

extension LocationViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchResults.removeAll()
        updateTableView()
        locationView.mapView.removeAnnotations(locationView.mapView.annotations)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResults.removeAll()
        } else {
            searchCompleter.queryFragment = searchText
        }
        locationView.showMap(false, hideSearchBar: false)
        updateTableView()
    }

    
}
