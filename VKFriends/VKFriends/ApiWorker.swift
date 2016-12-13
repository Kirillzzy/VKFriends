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



final class ApiWorker{
    
    static var friends = [VKFriendClass]()

    class func checkState() -> VK.States{
        return VK.state
    }
    

    class func logout() {
        VK.logOut()
        print("SwiftyVK: LogOut")
    }
    
    class var state: VK.States{
        get{
            return VK.state
        }
    }
    
    
    class func friendsGet(){
        _ = VK.API.Friends.get([
            .count : "0",
            .fields : "city,domain,photo_200_orig,online,last_seen"
            ]).send(
                onSuccess: {response in
                    //cleaning array
                    self.friends.removeAll()
                    for friend in response["items"].arrayValue{
                        var cityFriend = ""
                        if let cityName = friend["city", "title"].string{
                            cityFriend = cityName
                        }
                        let newFriend =
                            VKFriendClass(name: "\(friend["last_name"].stringValue) \(friend["first_name"].stringValue)",
                                city: cityFriend,
                                id: friend["id"].stringValue,
                                linkProfileImage: friend["photo_200_orig"].stringValue,
                                lastSeen: friend["last_seen", "time"].stringValue,
                                online: friend["online"].boolValue)
                        self.friends.append(newFriend)
                    }
                    self.friends.sort(by: {friend1, friend2 in friend1.getName() < friend2.getName()})
                },
                onError: {
                    error in print("error")
            })
    }
}
