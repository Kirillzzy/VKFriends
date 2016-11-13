//
//  FriendTableViewCell.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 13/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for friend: VKFriendClass){
        cityLabel.text = friend.getCity()
        nameLabel.text = friend.getName()
        profileImageView.image = friend.profileImage.image
    }

}
