//
//  PlaceDetailViewController.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/12.
//

import UIKit

// Class for Detail information view for selected place
class PlaceDetailViewController: UIViewController {

    // Necessary Variables
    var placeData : LocationData?
    var endorsedFriendsList : [AccountData] = []
    let defaults = UserDefaults.standard
    var dataSource: UICollectionViewDiffableDataSource<Int, AccountData>!
    
    // Outlets
    @IBOutlet weak var PlaceImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var HourLabel: UILabel!
    @IBOutlet weak var DescriptionTitleLabel: UILabel!
    @IBOutlet weak var EndorseLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UITextView!
    @IBOutlet weak var EndorseButton: UIImageView!
    @IBOutlet weak var EndorsedFriendsView: UICollectionView!
    
    
    // Container views for shadow effects
    @IBOutlet weak var StoreInfoContainer: UIView!
    @IBOutlet weak var CollectionViewContainer: UIView!
    @IBOutlet weak var StoreDescContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuring shadow effects for the container views
        StoreInfoContainer.layer.shadowColor = UIColor.black.cgColor
        StoreInfoContainer.layer.shadowOpacity = 0.5
        StoreInfoContainer.layer.shadowOffset = .zero
        StoreInfoContainer.layer.shadowRadius = 5
        
        CollectionViewContainer.layer.shadowColor = UIColor.black.cgColor
        CollectionViewContainer.layer.shadowOpacity = 0.5
        CollectionViewContainer.layer.shadowOffset = .zero
        CollectionViewContainer.layer.shadowRadius = 5
        
        StoreDescContainer.layer.shadowColor = UIColor.black.cgColor
        StoreDescContainer.layer.shadowOpacity = 0.5
        StoreDescContainer.layer.shadowOffset = .zero
        StoreDescContainer.layer.shadowRadius = 5
        
        // Display information configurations
        EndorsedFriendsView.delegate = self
        guard let place = placeData else {
            return
        }
        
        let memberId = defaults.object(forKey: "account_id") as? String ?? "";
        
        
        PlaceImage.image = UIImage(named: place.picture);
        NameLabel.text = place.name
        AddressLabel.text = "Location: \(place.address)"
        HourLabel.text = "Store Hour: \(place.hour)"
        DescriptionTitleLabel.text = "About \(place.name)"
        DescriptionLabel.text = place.description
        
        let isEndorsed = LocationDataManager.sharedInstance.isEndorsed(account_id: memberId, place: place)
        if isEndorsed {
            EndorseButton.image = UIImage(systemName: "heart.fill")
        } else {
            EndorseButton.image = UIImage(systemName: "heart")
        }
        
        // Add a tap gesture
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleTapEndorse(_:)))
        EndorseButton.addGestureRecognizer(tapGesture)
        
        // Configure collection view
        EndorsedFriendsView.collectionViewLayout = makeLayout()
        dataSource = UICollectionViewDiffableDataSource(collectionView: EndorsedFriendsView) { collectionView, indexPath, state in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EndorsementCell",
                                                          for: indexPath) as! EndorsementCollectionViewCell
            cell.ViewTitle.text = state.first_name
            cell.ViewImage.image = UIImage(named: state.profile_pic)?.circleMasked
            return cell
        }
        
        
        let endorsedList = place.endorsement
        endorsedFriendsList = AccountDataManager.sharedInstance.fetchFriendsEndorsement(memberId: memberId, endorsedList: endorsedList)
        EndorseLabel.text = "Endorsed by \(endorsedFriendsList.count) friends"
        var snapshot = NSDiffableDataSourceSnapshot<Int, AccountData>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(endorsedFriendsList)
        dataSource.apply(snapshot)
    }
    
    // Handle clicking endorse button
    // Adds or removes the data using DataManagers
    @objc func handleTapEndorse(_ recognizer: UITapGestureRecognizer) {
        guard let place = placeData else {
            return
        }
        guard let memberId = defaults.object(forKey: "account_id") as? String else {
            return
        }
        
        let placeId = place.id
        let isEndorsed = LocationDataManager.sharedInstance.editPlaceEndorsement(
            placeId: placeId,
            accountId: memberId)
        let accountEdited = AccountDataManager.sharedInstance.editPlaceEndorsement(accountId: memberId, placeId: placeId)
        
        if isEndorsed != accountEdited {
            return
        }
        if isEndorsed {
            EndorseButton.image = UIImage(systemName: "heart.fill")
        } else {
            EndorseButton.image = UIImage(systemName: "heart")
        }
    }

}
