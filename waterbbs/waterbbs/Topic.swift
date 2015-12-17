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
  var title:String!
  var subject:String!
  var userAvatar:String!
  var replies:String!
  var hits:String!
  var imageList:String!
  var last_reply_date:String!
  var pic_path:String?
  var user_nick_name:String!
  init(data:JSON) {
    self.topic_id = data["topic_id"].string
    self.title = data["title"].string
    self.subject = data["subject"].string
    self.userAvatar = data["userAvatar"].string
    self.replies = String(data["replies"])
    self.hits = String(data["hits"])
    self.imageList = data["imageList"].string
    self.last_reply_date = data["last_reply_date"].string
    self.pic_path = data["pic_path"].string
    self.user_nick_name = data["user_nick_name"].string
    //print(self.title)
  }
}
