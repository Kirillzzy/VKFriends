//
//  PersonInformationViewController.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 04/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit

class PersonInformationViewController: UIViewController {
    
    var name: String!
    var city: String!
    var id: String!
    var ProfileImage: UIImage!
   
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ProfileImageUIImageView: UIImageView!
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        cityLabel.text = city
        ProfileImageUIImageView.image = ProfileImage//ApiWorker.getPhotoByID(id: Int(id)!, size: "photo_130")
    }
    
    @IBAction func newMessageButtonPressed(_ sender: Any) {
       
    }

}

