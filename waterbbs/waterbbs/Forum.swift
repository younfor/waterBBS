//
//  Forum.swift
//  waterbbs
//
//  Created by y on 15/12/14.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit
import SwiftyJSON

class Forum: NSObject {
    // input fid , type
    var board_category_name:String! // 板块名称
    var board_category_id:String! //gid
    var board_category_type:String!
    var board_list:Array<ForumChild>? // 数组
  init(data:JSON) {
    self.board_category_name = data["board_category_name"].string
    self.board_category_id = String(data["board_category_id"])
    self.board_category_type = String(data["board_category_type"]);
    self.board_list = Array<ForumChild>()
    for forum in data["board_list"] {
      let child = ForumChild.init(data: forum.1)
      self.board_list?.append(child)
    }
  }
}
