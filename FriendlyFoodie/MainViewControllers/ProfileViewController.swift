//
//  ProfileViewController.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/11.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // Necessary variables
    let defaults = UserDefaults.standard;
    var accountToShow : AccountData? = nil
    var dataSource: UICollectionViewDiffableDataSource<Int, LocationData>!
    var profileEndorsedList: [LocationData] = []
    
    // IBOutlet connections
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ProfilePicBackground: UIView!
    @IBOutlet weak var YearLabel: UILabel!
    @IBOutlet weak var DescriptionTitleLabel: UILabel!
    @IBOutlet weak var DescriptionText: UITextView!
    @IBOutlet weak var EndorsementLabel: UILabel!
    @IBOutlet weak var ProfileEditButton: UIButton!
    @IBOutlet weak var EndorsedEateriesView: UICollectionView!
    @IBOutlet weak var ProfileInfoView: UIView!
    @IBOutlet weak var CollectionContainerView: UIView!
    @IBOutlet weak var DescriptionContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EndorsedEateriesView.delegate = self
        
        // Container view shadow effect configurations
        ProfileInfoView.layer.shadowColor = UIColor.black.cgColor
        ProfileInfoView.layer.shadowOpacity = 0.5
        ProfileInfoView.layer.shadowOffset = .zero
        ProfileInfoView.layer.shadowRadius = 5
        
        DescriptionContainer.layer.shadowColor = UIColor.black.cgColor
        DescriptionContainer.layer.shadowOpacity = 0.5
        DescriptionContainer.layer.shadowOffset = .zero
        DescriptionContainer.layer.shadowRadius = 5
        
        CollectionContainerView.layer.shadowColor = UIColor.black.cgColor
        CollectionContainerView.layer.shadowOpacity = 0.5
        CollectionContainerView.layer.shadowOffset = .zero
        CollectionContainerView.layer.shadowRadius = 5
        
        // Other configurations
        ProfileEditButton.addTarget(self, action: #selector(handleClickEdit), for: .touchDown)
        
        // Configure CollectionView
        EndorsedEateriesView.collectionViewLayout = makeLayout()
        dataSource = UICollectionViewDiffableDataSource(collectionView: EndorsedEateriesView) { collectionView, indexPath, state in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EndorsementCell",
                                                          for: indexPath) as! EndorsementCollectionViewCell
            cell.ViewTitle.text = state.name
            cell.ViewImage.image = UIImage(named: state.picture)?.circleMasked

            return cell
        }
    }
    
    // Handle click Edit for profile
    @objc func handleClickEdit() {
        let accountEditView = storyboard!.instantiateViewController(withIdentifier: "AccountEditVC") as! AccountEditViewController
        accountEditView.accountToEdit = accountToShow
        accountEditView.parentView = self
        self.present(accountEditView, animated: true, completion: nil)
    }
    
    // Configure the view with account data
    func updateProfileView(account: AccountData) {
        let UIProfileImage = UIImage(named: account.profile_pic)?.circleMasked
        ProfileImage.image = UIProfileImage
        ProfilePicBackground.backgroundColor = UIProfileImage?.averageColor
        NameLabel.text = "\(account.first_name) \(account.last_name)"
        YearLabel.text = "Member since \(account.year_joined)"
        DescriptionTitleLabel.text = "About \(account.first_name)"
        DescriptionText.text = account.description
        EndorsementLabel.text = "Endorsed \(account.endorsed_places.count) eateries"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure view depending on whether its the owner or someone else's account
        if (accountToShow == nil) {
            let account_id = defaults.object(forKey: "account_id") as? String ?? ""
            let account = AccountDataManager.sharedInstance.findAccount(account_id: account_id)
            accountToShow = account
            ProfileEditButton.titleLabel?.text = "Edit"
            ProfileEditButton.isUserInteractionEnabled = true
        } else {
            ProfileEditButton.titleLabel?.text = ""
            ProfileEditButton.isUserInteractionEnabled = false
        }
        
        guard let account = accountToShow else {
            print("No account defined");
            return
        }
        
        updateProfileView(account: account)
        let endorsedList = account.endorsed_places
        
        profileEndorsedList = LocationDataManager.sharedInstance.retrieveLocationData(endorsedList: endorsedList)
        var snapshot = NSDiffableDataSourceSnapshot<Int, LocationData>()
        snapshot.appendSections([0])
        snapshot.appendItems(profileEndorsedList)
        print("Updating Endorsed List for profile")
        print(profileEndorsedList)
        dataSource.apply(snapshot)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        accountToShow = nil
    }
}
