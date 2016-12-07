//
//  VKFriendClass.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 10/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import MapKit


class VKFriendClass: NSObject, MKAnnotation{
    private var name: String = ""
    private var city: String = ""
    private var id: String = ""
    private var online: Bool = false
    private var lastSeen: String = ""
    var profileImage: UIImageView = UIImageView()
    var linkProfileImage: String = ""{
        didSet{
            reloadProfileImage()
        }
    }
    
    var title: String?{
        get{
            return name
        }
    }
    
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, city: String?, id: String, linkProfileImage: String, lastSeen: String, online: Bool = false, coordinate: CLLocationCoordinate2D? = nil){
        self.name = name
        if let cityName = city{
            self.city = cityName
        }
        self.id = id
        self.linkProfileImage = linkProfileImage
        self.coordinate = coordinate ??  CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.online = online
        self.lastSeen = lastSeen
        super.init()
        self.translateUnixToStringLastSeen()
        self.getCoordinates()
    }
    
    func reloadProfileImage(){
        profileImage.sd_setImage(with: URL(string: linkProfileImage))
    }
    
    func getName() -> String{
        return name
    }
    
    func getCity() -> String{
        return city
    }
    
    func getId() -> String{
        return id
    }
    
    func getLinkPhoto() -> String{
        return linkProfileImage
    }
    
    func getOnline() -> Bool{
        return online
    }
    
    func getLastSeen() -> String{
        return lastSeen
    }
    
    func getCoordinates(){
        let geocoder = CLGeocoder()
       
        if city == ""{
            return
        }
        geocoder.geocodeAddressString(city, completionHandler: {(placemark, error) in
            if error != nil{
                return
            }
            if let location = placemark?[0].location?.coordinate{
                self.coordinate = location
            }
        })
    }
    
    
    func translateUnixToStringLastSeen(){
        if lastSeen == ""{
            return
        }
        let date = NSDate(timeIntervalSince1970: TimeInterval(Int(self.lastSeen)!))
        let calendar = NSCalendar.current
        var hour = String(calendar.component(.hour, from: date as Date))
        var minutes = String(calendar.component(.minute, from: date as Date))
        var day = String(calendar.component(.day, from: date as Date))
        let month = String(calendar.component(.month, from: date as Date))
        if hour.characters.count == 1{
            hour = "0" + hour
        }
        if minutes.characters.count == 1{
            minutes = "0" + minutes
        }
        if day.characters.count == 1{
            day = "0" + day
        }
        self.lastSeen = String("Last seen " + month + "." + day + " " + hour + ":" + minutes)
    }
    
    static func resizeImage(image: UIImage, newW: Double, newH: Double) -> UIImage {
        let newWidth = CGFloat(newW)
        let newHeight = CGFloat(newH)
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
