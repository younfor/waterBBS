//
//  Topic.swift
//  waterbbs
//
//  Created by y on 15/12/17.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit
import SwiftyJSON

class Topic: NSObject {
  var topic_id:String!
  var board_id:String!
  var title:String!
  var subject:String!
  var userAvatar:String!
  var replies:String!
  var hits:String!
  var imageList:String!
  var last_reply_date:String!
  var pic_path:String?
  var user_nick_name:String!
  var sourceWebUrl:String!
  override init() {
    super.init()
  }
  init(data:JSON) {
    print(data)
    self.board_id = String(data["board_id"])
    self.topic_id = String(data["topic_id"])
    self.title = data["title"].string
    self.subject = data["subject"].string
    self.userAvatar = data["userAvatar"].string
    self.replies = String(data["replies"])
    self.hits = String(data["hits"])
    self.imageList = data["imageList"].string
    self.last_reply_date = data["last_reply_date"].string
    self.pic_path = data["pic_path"].string
    self.user_nick_name = data["user_nick_name"].string
    self.sourceWebUrl = data["sourceWebUrl"].string
    
    //print(self.title)
  }
  
  func isPicTopic() -> Bool {
    if self.pic_path != "" {
      return true
    } else {
      return false
    }
  }
}
