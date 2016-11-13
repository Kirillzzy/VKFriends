//
//  ApiWorker.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 03/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import Foundation
import SwiftyVK
import AlamofireImage
import Alamofire



class ApiWorker: VKDelegate{
    
    var friends = [VKFriendClass]()
    var status: Bool = false
   
    static let sharedInstance: ApiWorker = {
        let instance = ApiWorker()
        return instance
    }()
    
    init(){
        VK.configure(appID: Constants.appID, delegate: self)
        VK.logIn()
    }
    
    func vkWillAuthorize() -> [VK.Scope] {
        
        return [.offline, .friends]
    }

    func vkDidUnauthorize() {
        //Called when user is log out.
    }
    
    func vkAutorizationFailedWith(error: VK.Error) {
        //Called when SwiftyVK could not authorize. To let the application know that something went wrong.
    }
    
    func vkShouldUseTokenPath() -> String? {
        //Called when SwiftyVK need know where a token is located.
        return nil //Path to save/read token or nil if should save token to UserDefaults
    }
    
    func vkWillPresentView() -> UIViewController {
        //Only for iOS!
        //Called when need to display a view from SwiftyVK.
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
    
    func login(){
        VK.logIn()
    }
    
    func checkState() -> VK.States{
        return VK.state
    }
    
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        print("HERE")
        print("_--------__-------_")
        self.friendsGet()
        //Called when the user is log in.
        //Here you can start to send requests to the API.
    }
    
    func logout() {
        VK.logOut()
        print("SwiftyVK: LogOut")
    }
    
    var state: VK.States{
        get{
            return VK.state
        }
    }
    
    
    func getFriendPhotoLink(friend: VKFriendClass){
        _ = VK.API.Photos.get([
            .ownerId :"\(friend.getId())",
            .albumId : "profile"]).send(
                onSuccess: {response in
                    friend.linkProfileImage = response["items", response["count"].intValue - 1, "photo_130"].stringValue
            },
                onError: {
                    error in print("SwiftyVK: photosGet fail \n \(error)")
                    friend.linkProfileImage = ""
            })
    }
    
    
    
    func friendsGet(){
        let req = VK.API.Friends.get([
            .count : "0",
            .fields : "city,domain"
            ])
        req.successBlock = {response in
            //cleaning array
            self.friends.removeAll()
            //getting Friends names, their cities and profile photos
            for friend in response["items"].arrayValue{
                var cityFriend = ""
                if let cityName = friend["city", "title"].string{
                    cityFriend = cityName
                }
                let newFriend =
                    VKFriendClass(name: "\(friend["last_name"].stringValue) \(friend["first_name"].stringValue)",
                    city: cityFriend,
                    id: friend["id"].stringValue,
                    linkProfileImage: "")
                self.friends.append(newFriend)
                self.getFriendPhotoLink(friend: newFriend)
            }
        }
        req.errorBlock = {error in print("error")}
        req.send()
    }
}
