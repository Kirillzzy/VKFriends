//
//  PersonInformationViewController.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 04/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit
import SDWebImage

class PersonInformationViewController: UIViewController {
    
    var name: String!
    var city: String!
    var id: String!
    var linkProfileImage: String!
    var lastSeen: String!
    var online: Bool!
   
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ProfileImageUIImageView: UIImageView!
    @IBOutlet weak var onlineLabel: UILabel!
    @IBOutlet weak var lastSeenLabel: UILabel!
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        cityLabel.text = city
        lastSeenLabel.text = lastSeen
        if online == true{
            onlineLabel.text = "Online"
        }else{
            onlineLabel.text = "Offline"
        }
        ProfileImageUIImageView.sd_setImage(with: URL(string: linkProfileImage))
        ProfileImageUIImageView.layer.masksToBounds = true
        ProfileImageUIImageView.layer.cornerRadius = 15
    }
    
    @IBAction func newMessageButtonPressed(_ sender: Any) {
       
    }
    
    @IBAction func buyFriendButtonPressed(_ sender: Any) {
        
    }

}

