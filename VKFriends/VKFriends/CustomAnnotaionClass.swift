//
//  CustomAnnotaionClass.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 13/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotaionClass: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var freind: VKFriendClass!
    init(coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
    }
}
