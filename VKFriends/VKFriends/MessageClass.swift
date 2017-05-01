//
//  MessageClass.swift
//  VKFriends
//
//  Created by Kirill Averyanov on 19/12/2016.
//  Copyright © 2016 Kirill Averyanov. All rights reserved.
//

import Foundation


class MessageClass{
  var userId: String!
  var fromId: String!
  var id: String!
  var text: String!
  var date: String!
  var readState: Bool!

  init(userId: String, fromId: String, id: String, text: String, date: String, readState: Bool){
    self.userId = userId
    self.fromId = fromId
    self.id = id
    self.text = text
    self.date = date
    self.readState = readState
  }

  init(){}
}
