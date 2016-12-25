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
    @IBOutlet weak var onlineImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 28
        //profileImageView.contentMode = UIViewContentMode.center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
