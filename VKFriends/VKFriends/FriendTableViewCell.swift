//
//  FriendTableViewCell.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 14/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameCityLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
