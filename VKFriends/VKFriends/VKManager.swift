//
//  VKManager.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 13/12/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import Foundation
import SwiftyVK


class VKManager: VKDelegate{

  init(){
    VK.configure(withAppId: Constants.VKappID, delegate: self)
  }

  func vkWillAuthorize() -> Set<VK.Scope> {
    return [.offline, .notifications, .wall, .friends, .messages]
  }

  func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
    print("Autorized")
    //ApiWorker.friendsGet()
    ApiWorker.getCurrentUser()
  }

  func vkAutorizationFailedWith(error: AuthError) {
    print("Autorization failed with error: \n\(error)")
  }

  func vkDidUnauthorize() {
  }

  func vkShouldUseTokenPath() -> String? {
    return nil
  }

  func vkWillPresentView() -> UIViewController {
    return UIApplication.shared.delegate!.window!!.rootViewController!
  }

  static let sharedInstance: VKManager = {
    let instance = VKManager()
    return instance
  }()

}
