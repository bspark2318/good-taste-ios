//
//  ProfileViewExtension.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/12.
//

import Foundation
import UIKit


// Collection View Delegate for profiles who have endorsed
// the establishment
extension PlaceDetailViewController: UICollectionViewDelegate {
    
    // Different segue configuration
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "ProfileDetailVC" {
            guard let detailVC = segue.destination as? ProfileViewController,
                let selectedRow = EndorsedFriendsView.indexPathsForSelectedItems?.first?.row else {
                    return
                }
            print("Profile to show")
            print(selectedRow)
            let account = endorsedFriendsList[selectedRow]
            detailVC.accountToShow = account
        }
    }
    
    // Also sourced from assignment 6 
    func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
                                                                                 heightDimension: NSCollectionLayoutDimension.absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            return section
        }
    }

}
