//
//  VKFriendsTests.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 20/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import XCTest
import UIKit
import Foundation
@testable import VKFriends


class VKFriendsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let photoURL = "https://vk.com/id355905867?z=photo355905867_424091544%2Falbum355905867_0%2Frev"
        let name = "Averyanov Grigory"
        let city = "Saint Petersburg"
        let friend = VKFriendClass(name: name, city: city, id: "355905867", linkProfileImage: photoURL)
        XCTAssertEqual(friend.getCity(), city)
        XCTAssertEqual(friend.getName(), name)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
