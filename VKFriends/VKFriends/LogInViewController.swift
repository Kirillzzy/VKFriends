//
//  LogInViewController.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 13/12/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit
import SwiftyVK

class LogInViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 5
        VK.logIn()
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        if ApiWorker.state == .authorized{
            performing()
        }else{
            VK.logIn()
        }
    }

    
    func performing(){
        performSegue(withIdentifier: "fromLoginSegue", sender: "perform")
    }
    
}

extension LogInViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromLoginSegue"{
            //let vc = segue.destination
        }
    }
}
