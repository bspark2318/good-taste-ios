//
//  ProfileViewExtension.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/12.
//

import Foundation
import UIKit


// Delegate for configuring collection view for
// places that have been endorsed
extension ProfileViewController: UICollectionViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaceDetailVC" {
            guard let placeDetailVC = segue.destination as? PlaceDetailViewController,
                let selectedRow = EndorsedEateriesView.indexPathsForSelectedItems?.first?.row else {
                    return
                }
            let place = profileEndorsedList[selectedRow]
            
            placeDetailVC.placeData = place
            return
    }
    }
        
    // Sourced from project 6 from the assignments
    // Configuring how the collection view looks
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
