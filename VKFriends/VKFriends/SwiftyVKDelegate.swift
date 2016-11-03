//
//  SwiftyVKClass.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 03/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import Foundation
import SwiftyVK


class SwiftyVKDelegate: VKDelegate{
    let appID = Constants.appID
    let scope = [VK.Scope.messages,.offline,.friends,.wall,.photos,.audio,.video,.docs,.market,.email]
    
    init(){
        VK.configure(appID: appID, delegate: self)
    }
    
    func vkWillAuthorize() -> [VK.Scope] {
        return scope
    }
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidAuthorize"), object: nil)
    }
    
    func vkDidUnauthorize() {
        //Called when user is log out.
    }
    
    func vkAutorizationFailedWith(error: VK.Error) {
        print("Autorization failed with error: \n\(error)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidNotAuthorize"), object: nil)
    }
    
    func vkShouldUseTokenPath() -> String? {
        //Called when SwiftyVK need know where a token is located.
        return nil //Path to save/read token or nil if should save token to UserDefaults
    }
    
    func vkWillPresentView() -> UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
    
    /*func vkWillPresentView() -> NSWindow? {
        //Only for OSX!
        //Called when need to display a window from SwiftyVK.
        return //Parent window for modal view or nil if view should present in separate window
    }*/
    
}

