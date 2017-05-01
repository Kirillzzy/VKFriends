//
//  MessageTableViewCell.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 20/12/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!

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
