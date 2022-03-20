//
//  mapViewDelegate.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/11.
//

import Foundation
import MapKit
import CoreLocation

// Delegate for the MapView
extension MapViewController: MKMapViewDelegate {
    
    // What happens when the pin gets selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // Diverges into two cases. One for featured place
        // and one for pinned place with no significance
        if view.reuseIdentifier == "FeaturedPlaceMarker" {
            guard let annotation = view.annotation as? FeaturedPlaceAnnotation else {
                return
            }
            dismissLocationDetailView()
            let placeDetailVC = storyboard!.instantiateViewController(withIdentifier: "PlaceDetailVC") as! PlaceDetailViewController
            
            guard let placeId = annotation.placeId else {
                return
            }
            let place = LocationDataManager.sharedInstance.retrieveLocationData(endorsedList: [placeId])[0]
            
            placeDetailVC.placeData = place
            let nav = UINavigationController(rootViewController: placeDetailVC)
            nav.modalPresentationStyle = .pageSheet
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [ .medium(), .large()]
            }
            present(nav, animated: true, completion: nil)
            
        } else {
            guard let annotation = view.annotation as? RegularPlaceAnnotation else {
                return
            }
            guard let identifier = annotation.identifier,
                    let place = LocationDataManager.sharedInstance.searchedPlaces[identifier] else {
                return
            }
            selectedPlace = place
            presentLocationDetailView()
        }
    }
    
    // Style the pin further
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? FeaturedPlaceAnnotation else {
            return nil
        }
        
        if (annotation.isEndorsed == 1) {
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "FeaturedPlaceMarker", for: annotation) as? FeaturedPlaceMarkerView else {
                return nil
            }
            
            annotationView.animatesWhenAdded = true
            annotationView.displayPriority = .defaultHigh
            annotationView.clusteringIdentifier = "Place"
            return annotationView
        } else {
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "SearchedPlaceMarker", for: annotation) as? SearchedPlaceMarkerView else {
                return nil}
            
            annotationView.animatesWhenAdded = true
            annotationView.displayPriority = .defaultHigh
            annotationView.clusteringIdentifier = "Place"
            return annotationView
        }
    }
}
