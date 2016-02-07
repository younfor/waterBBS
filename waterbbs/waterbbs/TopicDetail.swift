//
//  TopicDetail.swift
//  waterbbs
//
//  Created by y on 15/12/21.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit
import SwiftyJSON

class TopicDetail: NSObject {
  var page:String?
  var has_next:String?
  var total_num:String?
  var reply_list = Array<Reply>()
  var forumName:String?
  // topic
  var title:String?
  var topic_id:String?
  var mobileSign:String? //来自安卓或者iOS
  var create_date:String?
  var level:String?
  var icon:String?
  var userTitle:String?
  var user_nick_name:String?
  var reply_posts_id:String?
  // content
  var infors:[[String:String]]?
  var type:String?
  init(data:JSON) {
    //print(data)
    self.page = data["page"].string
    self.forumName = data["forumName"].string
    self.has_next = data["has_next"].string
    self.total_num = data["total_num"].string
    // topic 
    self.title = data["topic"]["title"].string
    self.topic_id = String(data["topic"]["topic_id"])
    self.reply_posts_id = String(data["topic"]["reply_posts_id"])
    self.mobileSign = data["topic"]["mobileSign"].string
    self.create_date = data["topic"]["create_date"].string
    self.level = String(data["topic"]["level"])
    self.icon = data["topic"]["icon"].string
    self.userTitle = data["topic"]["userTitle"].string
    self.user_nick_name = data["topic"]["user_nick_name"].string
    // content
    self.infors = [[String:String]]()
    for content in data["topic"]["content"] {
      self.infors?.append(["infor":(content.1)["infor"].string!,"type":String((content.1)["type"])])
    }
    // 评论
    for reply in data["list"] {
      reply_list.append(Reply(data: reply.1))
    }
  }
}
