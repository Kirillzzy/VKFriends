//
//  VKFriendsUITests.swift
//  VKFriendsUITests
//
//  Created by Kirill Averyanov on 20/11/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import XCTest

class VKFriendsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["List"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Bondarev Ivan: Moscow"].swipeUp()
        tablesQuery.staticTexts["Boytsov Vladimir: Saint Petersburg"].tap()
        app.buttons["Buy a friend for chatting"].tap()
        app.navigationBars["Boytsov Vladimir"].buttons["Friends"].tap()
        
    }
    
    func testExample2(){
        
        let app = XCUIApplication()
        app.otherElements["Mishutin Dmitry"].tap()
        app.buttons["More Info"].tap()
        app.buttons["New Message"].tap()
        app.navigationBars["Person"].buttons["Friends"].tap()
        
    }
    
}
