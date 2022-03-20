//
//  FeaturedTableViewCell.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/12.
//

import UIKit

// Table View for Featured places 
class FeaturedTableViewCell: UITableViewCell {

    @IBOutlet weak var endorsementLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
