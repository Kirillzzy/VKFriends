//
//  ApiWorker.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 03/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import Foundation
import SwiftyVK
import Alamofire
import MapKit



class ApiWorker{

  static var friends = [VKFriendClass]()
  static var locationsOfFriends = [String: CLLocationCoordinate2D]()

  class func checkState() -> VK.States{
    return VK.state
  }


  class func logout() {
    VK.logOut()
    print("SwiftyVK: LogOut")
  }

  class var state: VK.States{
    return VK.state
  }


  class func friendsGet(callback: @escaping (_ friends: [VKFriendClass]?) -> Void){
    var friends = [VKFriendClass]()
    _ = VK.API.Friends.get([
      .count : "0",
      .fields : "city,domain,photo_200_orig,online,last_seen"
      ]).send(
        onSuccess: {response in
          //cleaning array
          friends.removeAll()
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
            if !self.locationsOfFriends.keys.contains(newFriend.getId()){
              newFriend.getCoordinates(callback: { coords in
                if coords != nil{
                  self.locationsOfFriends[newFriend.getId()] = coords!
                }
              })
            }else{
              newFriend.coordinate = self.locationsOfFriends[newFriend.getId()]!
            }
            friends.append(newFriend)
          }
          //friends.sort(by: {friend1, friend2 in friend1.getName() < friend2.getName()})
          self.friends = friends
          callback(friends)
      },
        onError: {
          error in print(error)
          if (error as NSError).code == 15{
            VK.logOut()
            VK.logIn()
          }
          callback(nil)
      })
  }


  class func messagesGetByUser(userId: String) -> [MessageClass]{
    var messagesFromUser = [MessageClass]()
    var status = false
    _ = VK.API.Messages.getHistory([
      .count: "100",
      .userId: userId]).send(
        onSuccess: { response in
          for message in response["items"].arrayValue{
            if message["body"].stringValue == ""{
              continue
            }
            messagesFromUser.append(MessageClass(userId: message["user_id"].stringValue,
                                                 fromId: message["from_id"].stringValue,
                                                 id: message["id"].stringValue,
                                                 text: message["body"].stringValue,
                                                 date: message["date"].stringValue,
                                                 readState: message["read_state"].boolValue))
          }
          messagesFromUser.reverse()
          status = true
      },
        onError: {
          error in print(error)
          if (error as NSError).code == 15{
            VK.logOut()
            VK.logIn()
          }
          status = true
      })
    while(!status){}
    return messagesFromUser
  }

  class func sendMessageToUser(userId: String, message: String){
    _ = VK.API.Messages.send([
      .userId: userId,
      .message: message]).send(
        onSuccess: { response in
          print("Success send message to \(userId)")
      }, onError: { error in
        print(error)
      })
  }


  class func getCurrentUser(){
    _ = VK.API.Users.get([
      .fields: "photo_200_orig"
      ]).send(onSuccess: { response in
        CurrentUserClass.firstName = response[0, "first_name"].stringValue
        CurrentUserClass.lastName = response[0, "last_name"].stringValue
        CurrentUserClass.id = response[0, "id"].stringValue
        CurrentUserClass.linkProfileImage = response[0, "photo_200_orig"].stringValue
      }, onError: { error in
        print(error)
      })
  }
  
}
