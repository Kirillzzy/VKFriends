//
//  File.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 28/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import Foundation
import RealmSwift


class User: Object{
    dynamic var latidute = 0.0
    dynamic var longitude = 0.0
    dynamic var created = Date()
}
