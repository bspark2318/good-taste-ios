//
//  FeaturedTableViewController.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/12.
//

import UIKit

// Class for TableView with the featured recommendations
class FeaturedTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    var memberId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuration upon first launch
        // Configured here since this is the first view the app directs to
        if (defaults.object(forKey: "isFirstLaunch") == nil) {
            defaults.set(true, forKey: "isFirstLaunch")
            defaults.set(1, forKey: "LaunchCount")
            let splashScreenVC = storyboard!.instantiateViewController(withIdentifier: "SplashScreenVC") as! SplashScreenViewController
            splashScreenVC.modalPresentationStyle = .fullScreen
            self.present(splashScreenVC, animated: true, completion: nil)
        } else {
            var count = defaults.integer(forKey: "LaunchCount")
            count += 1
            if count == 3 {
                // Present alert for rating if third time launching
                let alert = UIAlertController(title: "Rate Good Target", message: "Please rate us on App Store!", preferredStyle: .alert)
                alert.addAction(UIAlertAction( title: "Rate", style: .default, handler: nil))
                alert.addAction(UIAlertAction( title: "No Thanks", style: .default, handler: nil))
                present(alert, animated: true)
            }
            defaults.set(count, forKey: "LaunchCount")
        }
        
        // Load data
        LocationDataManager.sharedInstance.loadLocationDataFromPlist();
        AccountDataManager.sharedInstance.loadAccountDataFromPlist();
        // Configure some information
        let userProfileId = AccountDataManager.sharedInstance.accountArray[0].id;
        memberId = userProfileId
        defaults.set(userProfileId, forKey: "account_id");
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData() 
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return LocationDataManager.sharedInstance.placeArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedTableViewCell", for: indexPath) as! FeaturedTableViewCell
        let place = LocationDataManager.sharedInstance.placeArray[indexPath.row]
        let endorsementCount = AccountDataManager.sharedInstance.fetchFriendsEndorsementCount(memberId: memberId, endorsedList: place.endorsement)
        cell.placeImage.image = UIImage(named: place.picture )?.circleMasked
        cell.nameLabel.text = place.name
        cell.endorsementLabel.text = "Endorsed by \(endorsementCount) friends"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? PlaceDetailViewController,
                let index = tableView.indexPathForSelectedRow?.row
                else {
                    return
            }
        // Segue configuration for data detail
        detailViewController.placeData = LocationDataManager.sharedInstance.placeArray[index]
    }
}


