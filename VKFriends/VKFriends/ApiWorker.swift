//
//  ApiWorker.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 03/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import Foundation
import SwiftyVK


final class ApiWorker{
    
    static var namesAndCities = [String: String]()
   
    class func authorize() {
        //VK.logOut()
        //print("SwiftyVK: LogOut")
        VK.logIn()
        print("SwiftyVK: authorize")
    }
    
    
    
    class func logout() {
        VK.logOut()
        print("SwiftyVK: LogOut")
    }
    
    class func state() -> VK.States{
        return VK.state
    }
    
    class func captcha() {
        let req = VK.API.custom(method: "captcha.force")
        req.successBlock = {response in print("SwiftyVK: Captcha success \n \(response)")}
        req.errorBlock = {error in print("SwiftyVK: Captcha fail \n \(error)")}
        req.send()
    }
    
    
    
    class func validation() {
        let req = VK.API.custom(method: "account.testValidation")
        req.successBlock = {response in print("SwiftyVK: Captcha success \n \(response)")}
        req.errorBlock = {error in print("SwiftyVK: Captcha fail \n \(error)")}
        req.send()
    }
    
    
    
    class func usersGet() {
        /*let req = VK.API.Users.get(
         [VK.Arg.userId : "1"]).send(
         method: .Get,
         onSuccess: {response in print(response)},
         onError: {error in print(error)}
         )*/
        let req = VK.API.Users.get([VK.Arg.userId : "1"])
        req.maxAttempts = 1
        req.timeout = 10
        req.asynchronous = true
        req.catchErrors = true
        req.successBlock = {response in print("SwiftyVK: usersGet success \n \(response)")}
        req.errorBlock = {error in print("SwiftyVK: usersGet fail \n \(error)")}
        req.send()
    }
    
    
    
    class func friendsGet(){
        let req = VK.API.Friends.get([
            .count : "0",
            .fields : "city,domain"
            ])
        req.successBlock = {response in
            namesAndCities.removeAll()
            for i in 0..<response["count"].intValue{
                let nameFriend = "\(response["items", i, "last_name"].stringValue) \(response["items", i, "first_name"].stringValue)"
                var cityFriend = ""
                if let cityName = response["items", i, "city", "title"].string{
                    cityFriend = cityName
                }
                namesAndCities[nameFriend] = cityFriend
            }
        }
        req.errorBlock = {error in print("error")}
        req.send()
    }
    
    
    
    
    class func uploadPhoto(userID: Int) {
        let data = try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "testImage", ofType: "jpg")!))
        let media = Media(imageData: data, type: .JPG)
        let req = VK.API.Upload.Photo.toWall.toUser(media, userId: "\(userID)")
        req.progressBlock = { (done, total) -> () in print("SwiftyVK: uploadPhoto progress: \(done) of \(total))")}
        req.successBlock = {response in print("SwiftyVK: uploadPhoto success \n \(response)")}
        req.errorBlock = {error in print("SwiftyVK: uploadPhoto fail \n \(error)")}
        req.send()
    }
}
