//
//  ViewController.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 03/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    let vk: SwiftyVKDelegate = SwiftyVKDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiWorker.authorize()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            if(String(describing: ApiWorker.state()) == "authorized"){
                ApiWorker.friendsGet()
            }
        })
    }


}

