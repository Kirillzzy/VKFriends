//
//  LogInViewController.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 13/12/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit
import SwiftyVK
import SystemConfiguration

class LogInViewController: UIViewController {

  @IBOutlet weak var loginButton: UIButton!


  override func viewDidLoad() {
    super.viewDidLoad()
    loginButton.layer.masksToBounds = true
    loginButton.layer.cornerRadius = 5
    VK.logIn()
  }

  @IBAction func loginButtonPressed(_ sender: Any) {
    if !isInternetAvailable(){
      showErrorAlert()
      return
    }
    if ApiWorker.state == .authorized{
      ApiWorker.getCurrentUser()
      performing()
    }else{
      VK.logIn()
    }
  }


  func performing(){
    performSegue(withIdentifier: "fromLoginSegue", sender: "perform")
  }

  func showErrorAlert(){
    let alert = UIAlertController(title: "Error", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }

  func isInternetAvailable() -> Bool
  {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)

    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
        SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
      }
    }

    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
      return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
  }

}

extension LogInViewController{
  override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    if segue.identifier == "fromLoginSegue"{
      //let vc = segue.destination
    }
  }
}
