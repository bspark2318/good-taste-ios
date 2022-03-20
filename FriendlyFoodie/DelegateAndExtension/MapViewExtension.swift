//
//  MapViewExtension.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/13.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

// Delegate for the UISearchBar
extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}

// In support of LocationTable
extension MapViewController : HandleMapSearch {
        
    // Protocol method to follow to handle what to do when
    // a pin needs to dropped
    func dropPinZoomIn(placemark: MKPlacemark) {
            selectedPlace = placemark
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark.coordinate
                annotation.title = placemark.name
                if let city = placemark.locality,
                let state = placemark.administrativeArea {
                    annotation.subtitle = "\(city) \(state)"
                }
                mapView.addAnnotation(annotation)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
                mapView.setRegion(region, animated: true)
    }
}

// Location Manager Delegate for handling location information from the app
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            // Do something
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}

// Table View Controller for displaying results from the
// Search bar search on the mapView
class LocationSearchTable : UITableViewController {
    var matchingItems: [MKMapItem] = []
    var parentView: MapViewController? = nil
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate : HandleMapSearch? = nil
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell")!
               let selectedItem = matchingItems[indexPath.row].placemark
               cell.textLabel?.text = selectedItem.name
               let address = "\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")"
       cell.detailTextLabel?.text = address
               return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        dismiss(animated: true, completion: nil)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: selectedItem.coordinate, span: span)
        mapView?.setRegion(region, animated: true)
        parentView?.centerModalView(placeMark: selectedItem)
    }
    
}

// How to handle updating search results
extension LocationSearchTable : UISearchResultsUpdating {
    
    // Sends an API request to get information about the map and
    // locations included in it
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else {
                  return
              }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}
