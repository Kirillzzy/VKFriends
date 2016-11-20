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
    
    init(name: String, city: String?, id: String, linkProfileImage: String, coordinate: CLLocationCoordinate2D? = nil){
        self.name = name
        if let cityName = city{
            self.city = cityName
        }
        self.id = id
        self.linkProfileImage = linkProfileImage
        self.coordinate = coordinate ??  CLLocationCoordinate2D(latitude: 0, longitude: 0)
        super.init()
        self.getCoordinates()
    }
    
    func reloadProfileImage(){
        //if linkProfileImage == ""{
            profileImage.image = #imageLiteral(resourceName: "camera")
        if linkProfileImage != ""{
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
                self.coordinate = location
            }
        })
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
