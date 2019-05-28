//
//  LocationView.swift
//  LocationManager
//
//  Created by Daniel Henshaw on 26/5/19.
//  Copyright © 2019 Dan Henshaw. All rights reserved.
//

import UIKit
import MapKit

class LocationView: UIView {
    
    // MARK: - Properties
    
    lazy var mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()

    lazy var mapAnnotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        return annotation
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.showsCancelButton = true
        search.sizeToFit()
        search.isUserInteractionEnabled = true
        search.placeholder = NSLocalizedString("Search for places", comment: "")
        return search
    }()
    
    lazy var segmentedController: UISegmentedControl = {
        let controller = UISegmentedControl(items: ["SEARCH", "CURRENT LOCATION"])
        controller.selectedSegmentIndex = 0
        return controller
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        return table
    }()
    
    lazy var viewStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        return stack
    }()
    
    
    // MARK: - Constraint variables
    
    var searchBarHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    func setupView() {
        addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        searchBarHeightConstraint = searchBar.heightAnchor.constraint(equalToConstant: 60)
        searchBarHeightConstraint?.isActive = true
        
        addSubview(segmentedController)
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        segmentedController.heightAnchor.constraint(equalToConstant: 38).isActive = true
        segmentedController.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        segmentedController.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        segmentedController.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12).isActive = true
        
        addSubview(viewStackView)
        viewStackView.translatesAutoresizingMaskIntoConstraints = false
        viewStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8).isActive = true
        viewStackView.bottomAnchor.constraint(equalTo: segmentedController.topAnchor, constant: -8).isActive = true
        viewStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        viewStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        
        viewStackView.addArrangedSubview(mapView)
        viewStackView.addArrangedSubview(tableView)
        
        mapView.isHidden = true
    }

    
    func setMapCentrePoint(for location: Coordinate) {
        let regionRadius: CLLocationDistance = 200000
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setCenter(location, animated: true)
    }
    
    func addAnnotation(at location: Coordinate, for place: Placemark) {
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.title = place.placemark.locality
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    func showMap(_ showMap: Bool, hideSearchBar: Bool) {
        mapView.isHidden = !showMap
        tableView.isHidden = showMap
        searchBar.isHidden = hideSearchBar
        
        let searchBarHeight: CGFloat = hideSearchBar ? 0 : 60
        searchBarHeightConstraint?.isActive = false
        searchBarHeightConstraint = self.searchBar.heightAnchor.constraint(equalToConstant: searchBarHeight)
        searchBarHeightConstraint?.isActive = true
        layoutIfNeeded()
        
        if hideSearchBar {
            searchBar.resignFirstResponder()
        } else {
            searchBar.becomeFirstResponder()
        }
    }
}
