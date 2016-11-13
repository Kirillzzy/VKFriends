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


class VKFriendClass{
    private var name: String = ""
    private var city: String = ""
    private var id: String = ""
    var profileImage: UIImageView = UIImageView()
    var linkProfileImage: String = ""{
        didSet{
            reloadProfileImage()
        }
    }
    var coordinates: CLLocationCoordinate2D
    
    
    init(name: String, city: String?, id: String, linkProfileImage: String){
        self.name = name
        if let cityName = city{
            self.city = cityName
        }
        self.id = id
        self.linkProfileImage = linkProfileImage
        self.coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        getCoordinates()
    }
    
    func reloadProfileImage(){
        if linkProfileImage == ""{
            profileImage.image = #imageLiteral(resourceName: "camera")
        }else{
            //profileImage.image = UIImage(named: "reloadControlGif")
            profileImage.sd_setImage(with: URL(string: linkProfileImage))
        }
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
                self.coordinates = location
            }
        })
    }
    
}
