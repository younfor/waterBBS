//
//  Reply.swift
//  waterbbs
//
//  Created by y on 15/12/21.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit
import SwiftyJSON

class Reply: NSObject {
  var reply_content:String?
  var reply_type:String?
  var reply_name:String?
  var reply_posts_id:String?
  var position:String? // 楼层编号
  var posts_date:String? //回复时间
  var icon:String? // 头像
  var level:String?
  var userTitle:String?
  var reply_status:String?
  var status:String?
  var title:String?
  var is_quote:String?
  var quote_pid:String?
  var quote_content:String?
  var topic:String?
  init(data:JSON) {
  }
}
