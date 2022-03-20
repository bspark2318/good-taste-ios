//
//  PlaceMarkerView.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/11.
//

import Foundation
import MapKit

// Sourced how to create custom annotation views from
// https://blog.kulman.sk/using-custom-annotation-views-in-mkmapview/

// Annotation view for featured places
class FeaturedPlaceMarkerView: MKMarkerAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: "FeaturedPlaceMarker")
        
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "Place"
            displayPriority = .defaultLow
            markerTintColor = .systemBlue
            glyphImage = UIImage(systemName: "pin.fill")
        }
    }
}


// Annotation view for non-featured places
class SearchedPlaceMarkerView: MKMarkerAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: "SearchedPlaceMarker")
        
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "Place"
            displayPriority = .defaultLow
            markerTintColor = .systemRed
            glyphImage = UIImage(systemName: "pin.fill")
        }
    }
}
