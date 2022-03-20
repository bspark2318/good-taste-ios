//
//  PlaceAnnotation.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/11.
//

import MapKit

// MARK: Class for MKPointAnnotation with Featured Places
class FeaturedPlaceAnnotation: MKPointAnnotation {
    var name: String?
    var placeId: Int?
    var isEndorsed: Int?
    var longDescription: String?
    var endorsementCount: Int?
}

// MARK: Class for MKPointAnnotation with Featured Places
class RegularPlaceAnnotation: MKPointAnnotation {
    var name: String?
    var isEndorsed: Int?
    var longDescription: String?
    var identifier: String?
}
