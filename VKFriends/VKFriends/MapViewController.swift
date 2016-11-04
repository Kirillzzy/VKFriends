//
//  ViewController.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 03/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class MapViewController: UIViewController {

    let vk: SwiftyVKDelegate = SwiftyVKDelegate()
    var jsonFriends: JSON = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiWorker.authorize()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            if(String(describing: ApiWorker.state()) == "authorized"){
                ApiWorker.friendsGet()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    //magic
                })
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromMapSegue"{
            if let vc = segue.destination as? PersonInformationViewController{
                if let index = sender as? Int{
                    //goto controller and give information
                }
            }
        }
    }
}

