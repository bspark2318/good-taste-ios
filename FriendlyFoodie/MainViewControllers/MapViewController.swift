//
//  MapViewController.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/11.
//

import UIKit
import MapKit
import CoreLocation

// UIView controller that handles the map view as well
class MapViewController: UIViewController {
    
    // Necessary variables
    var plist : NSDictionary = NSDictionary();
    var selectedPlace : MKPlacemark? = nil
    let locationManager = CLLocationManager()
    
    // IBOutlet connections
    @IBOutlet weak var mapView: MKMapView!
    
    //ModalView Configuration
    @IBOutlet weak var AddModalView: UIView!
    @IBOutlet weak var ModalPlaceName: UILabel!
    @IBOutlet weak var ModalNoButton: UIButton!
    @IBOutlet weak var ModalYesButton: UIButton!
    
    // LocationDetailModal
    @IBOutlet weak var LocationDetailView: UIView!
    @IBOutlet weak var LDNameLabel: UILabel!
    @IBOutlet weak var LDAddressLabel: UILabel!
    @IBOutlet weak var LDAddButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure outlet views a bit
        AddModalView.layer.cornerRadius = 20
        LocationDetailView.layer.cornerRadius = 15
        LDNameLabel.numberOfLines = 2
        LDAddressLabel.numberOfLines = 2
        
        // Configure Map
        mapView.delegate = self;
        mapView.pointOfInterestFilter = .excludingAll;
        LocationDataManager.sharedInstance.annotateMapViewList(mapView: mapView);
    
        // Register Annotation View
        mapView.register(FeaturedPlaceMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: "FeaturedPlaceMarker")
        mapView.register(FeaturedPlaceMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: "SearchedPlaceMarker")
        
        // Configuration for Location Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Configure search table
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchResult") as! LocationSearchTable
        locationSearchTable.mapView = mapView
        locationSearchTable.parentView = self
        locationSearchTable.handleMapSearchDelegate = self
        let srchCtr = UISearchController(searchResultsController: locationSearchTable)
        srchCtr.searchBar.delegate = self
        srchCtr.searchBar.placeholder = "Search for a restaurant"
        srchCtr.searchBar.showsCancelButton = true
        srchCtr.searchResultsUpdater = locationSearchTable
        navigationItem.searchController = srchCtr
        definesPresentationContext = true
        
        // Configure Modal views
        ModalPlaceName.numberOfLines = 2;
        ModalYesButton.addTarget(self,
                                 action: #selector(handleClickYesButton),
                                 for: .touchDown)
        ModalNoButton.addTarget(self,
                                 action: #selector(handleClickNoButton),
                                 for: .touchDown)
        
        LDAddButton.addTarget(self,
                              action: #selector(handleClickYesButton),
                              for: .touchDown)
        
    }
    
    
    // Animation to center the modal view
    func centerModalView(placeMark: MKPlacemark) {
        dismissLocationDetailView()
        selectedPlace = placeMark
        ModalPlaceName.text = placeMark.name
        UIView.animate(withDuration: 0.2, delay: 0.15, options: [.curveLinear], animations: {
            self.AddModalView.center = self.view.center
        }, completion: {_ in
            print("Center Modal View animated to the center of screen");
        })
    }
    
    // Handle clicking on yes button for the modal view
    @objc func handleClickYesButton() {
        guard let placeMark = selectedPlace else {
            return
        }
        dismissModalView()
        // Present Input form for the view
        let placeInputView = storyboard!.instantiateViewController(withIdentifier: "PlaceInfoInputVC") as! PlaceInfoInputViewController
        placeInputView.selectedPlace = placeMark
        placeInputView.mapView = mapView
        self.present(placeInputView, animated: true, completion: nil)
    }
    
    // Handle clicking on no button for the modal view
    @objc func handleClickNoButton() {
        guard let placeMark = selectedPlace else {
            return
        }
        LocationDataManager.sharedInstance.annotateMapViewRegularPlace(mapView: mapView, place: placeMark)
        dismissModalView()
    }
    
    // Helper function to dismiss the view
    func dismissModalView() {
        UIView.animate(withDuration: 0.2, delay: 0.15, options: [.curveLinear], animations: {
            self.AddModalView.center = CGPoint(x: 700, y: 350)
        }, completion: {_ in
            print("Dismissed the modal view");
        })
    }
    
    // Configure Location Detail Modal View and present it
    func presentLocationDetailView() {
        LDNameLabel.text = selectedPlace?.name
        let address = "\(selectedPlace?.thoroughfare ?? ""), \(selectedPlace?.locality ?? ""), \(selectedPlace?.subLocality ?? ""), \(selectedPlace?.administrativeArea ?? ""), \(selectedPlace?.postalCode ?? ""), \(selectedPlace?.country ?? "")"
        
        LDAddressLabel.text = address
        UIView.animate(withDuration: 0.2, delay: 0.15, options: [.curveLinear], animations: {
            self.LocationDetailView.center = CGPoint(x: self.view.frame.width / 2, y: 4 * self.view.frame.height / 5)
        }, completion: {_ in
            print("Animation complete for Location Detail View");
        })
    }
    
    // Dismiss the Location Detail View Modal
    func dismissLocationDetailView() {
        UIView.animate(withDuration: 0.2, delay: 0.15, options: [.curveLinear], animations: {
            self.LocationDetailView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height)
        }, completion: {_ in
            print("Animation complete for Location Detail View");
        })
    }
    
    
}
