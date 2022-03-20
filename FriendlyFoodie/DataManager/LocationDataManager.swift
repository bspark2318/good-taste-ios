//
//  LocationDataManager.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/11.
//

import Foundation
import MapKit

public class LocationDataManager {
    public static let sharedInstance = LocationDataManager();
    
    // Information Storage
    var placeArray : [LocationData] = []
    
    
    // Some initial configuration for proper functioning without backend
    var searchedPlaces : [String : MKPlacemark] = ["<+41.88467100,-87.64775634> radius 141.17" : MKPlacemark(), "<+42.02379441,-87.90970880> radius 141.17" : MKPlacemark(), "<+41.80000325,-87.59595215> radius 141.17" : MKPlacemark(), "<+41.89822038,-87.62128294> radius 141.17": MKPlacemark(),
        "<+41.91956361,-87.69159140> radius 141.17" : MKPlacemark()]
    
    
    
    // Making the class a singleton
    fileprivate  init() {}
    
    
    // MARK: LocationDataManager Class Methods
    
    // Loads the Data and annotates the map
    func loadLocationDataFromPlist() {
        let dataPath = Bundle.main.path(forResource: "Places", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: dataPath ?? "") ?? NSDictionary()
        guard let places = plist["places"] as? [NSDictionary] else {
            print("No Places provided")
            return
        }
        
        // Convert into proper data structures
        for place in places {
            if let id = place["id"] as? Int,
               let lat = place["lat"] as? Double,
               let long = place["long"] as? Double,
               let name = place["name"] as? String,
               let picture = place["picture"] as? String,
               let description = place["description"] as? String,
               let hour = place["hour"] as? String,
               let address = place["address"] as? String,
               let endorsement = place["endorsement"] as? [String] {
                
                let newPlace = LocationData(
                    id: id, name: name,
                    description: description,
                    lat: lat, long: long,	
                    hour: hour, address: address,
                    picture: picture,
                    endorsement: endorsement)
                placeArray.append(newPlace)
                
            }
        }
        print("Places Successfully loaded");
        print(placeArray)
        return ;
    }
    
    // Helper function to annotate the map
    func annotateMapViewList(mapView: MKMapView) {
        for place in placeArray {
            annotateMapViewFeaturedPlace(mapView: mapView, place: place)
        }
    }
    
    // Helper function to add featured place to the mapView
    func addFeaturedPlace(mapView: MKMapView, place: LocationData) {
        placeArray.append(place)
        annotateMapViewFeaturedPlace(mapView: mapView, place: place)
    }
    
    
    // Helper function to annotate the map with featured place
    func annotateMapViewFeaturedPlace(mapView: MKMapView, place: LocationData) {
        let newAnnotation = FeaturedPlaceAnnotation()
        newAnnotation.coordinate = CLLocationCoordinate2DMake(
            place.lat, place.long);
        newAnnotation.title = place.name;
        newAnnotation.longDescription = place.description
        newAnnotation.placeId = place.id;
        newAnnotation.isEndorsed = 1;
        mapView.addAnnotation(newAnnotation)
    }
    
    // Helper function to annotate the map with regular  place
    func annotateMapViewRegularPlace(mapView: MKMapView, place: MKPlacemark) {
        guard let identifier = place.region?.identifier else {
            return
        }
        if searchedPlaces[identifier] != nil {
            return
        }

        searchedPlaces[identifier] = place
        let newAnnotation = RegularPlaceAnnotation()
        newAnnotation.name = place.name
        newAnnotation.coordinate = place.coordinate
        newAnnotation.isEndorsed = 0;
        newAnnotation.identifier = identifier
        mapView.addAnnotation(newAnnotation)
    }
    
    // Return whether the place is endorsed by the member
    func isEndorsed(account_id: String, place: LocationData) -> Bool {
        let endorsedList = place.endorsement
        for endorsed_id in endorsedList {
            if endorsed_id == account_id {
                return true
            }
        }
        return false
    }
    
    // Returns whether the place is endorsed (true if newly endorsed)
    // Edits the endorsement list of the place
    func editPlaceEndorsement(placeId: Int, accountId: String) -> Bool {
        
        for (i, place) in placeArray.enumerated() {
            if place.id == placeId {
                
                for (j, endorseId) in place.endorsement.enumerated() {
                    if endorseId == accountId {
                        placeArray[i].endorsement.remove(at: j)
                        print("Removed the place")
                        print(placeArray[i])
                        return false
                    }
                }
                
                print("Adding the place")
                placeArray[i].endorsement.append(accountId)
                print(placeArray[i])
                return true
            }
        }
        print("Nothing happened")
        return false
    }
    
    // Retrive location data based on the given list 
    func retrieveLocationData(endorsedList: [Int]) -> [LocationData] {
        var returnList: [LocationData] = []
        
        for endorsedId in endorsedList {
            for place in placeArray {
                if place.id == endorsedId {
                    returnList.append(place)
                }
            }
        }
        
        return returnList
    }
}
