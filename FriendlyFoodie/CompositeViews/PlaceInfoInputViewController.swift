//
//  PlaceInfoInputViewController.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/15.
//

import UIKit
import MapKit


// Class
class PlaceInfoInputViewController: UIViewController {

    // Necessary variables
    var selectedPlace: MKPlacemark? = nil
    var mapView: MKMapView? = nil
    
    // IB Outlet connections
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var AddressInput: UITextField!
    @IBOutlet weak var StoreHourInput: UITextField!
    @IBOutlet weak var ShortDescriptionInput: UITextView!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ShortDescriptionInput.text = ""
        ShortDescriptionInput.layer.borderWidth = 1
        ShortDescriptionInput.layer.borderColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0).cgColor
        SubmitButton.addTarget(self,
                               action: #selector(handleClickSubmitButton),
                               for: .touchDown)
        CancelButton.addTarget(self,
                               action: #selector(handleClickCancelButton),
                               for: .touchDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NameInput.text = selectedPlace?.name ?? ""
        let address = "\(selectedPlace?.thoroughfare ?? ""), \(selectedPlace?.locality ?? ""), \(selectedPlace?.subLocality ?? ""), \(selectedPlace?.administrativeArea ?? ""), \(selectedPlace?.postalCode ?? ""), \(selectedPlace?.country ?? "")"
        AddressInput.text = address
    }

    // Handle submitting for new information for the eatery
    @objc func handleClickSubmitButton() {
        let name = NameInput.text
        if name == "" {
            let alert = UIAlertController(title: "Input Error", message: "Eatery name cannot be blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        guard let mapView = mapView else {
            return
        }

        let address = AddressInput.text != "" ? AddressInput.text : "N/A"
        let storeHour = StoreHourInput.text == "" ? "N/A" : StoreHourInput.text
        let description = ShortDescriptionInput.text
        
        let newLocationData = LocationData(id: LocationDataManager.sharedInstance.placeArray.count,
                                           name: name ?? "",
                                           description: description ?? "",
                                           lat: selectedPlace?.coordinate.latitude ?? 0, long: selectedPlace?.coordinate.longitude ?? 0,
                                           hour: storeHour ?? "N/A",
                                           address: address ?? "N/A",
                                           picture: "food_placeholder",
                                           endorsement: [])
        LocationDataManager.sharedInstance.addFeaturedPlace(mapView: mapView, place: newLocationData)
        
        dismiss(animated: true, completion: nil)
    }
    
    // Handle click cancel. Dismiss the view
    @objc func handleClickCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
