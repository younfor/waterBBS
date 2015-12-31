//
//  MessageGroup.swift
//  waterbbs
//
//  Created by y on 15/12/31.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageGroup: NSObject {
  var toUserName:String?
  var plid:String?
  var lastUserName:String?
  var lastUserId:String?
  var lastSummary:String?
  var toUserAvatar:String?
  var isNew:String?
  var lastDateline:String?
  var pmid:String?
  var toUserId:String?
  init(data:JSON) {
    self.toUserName = data["toUserName"].string
    self.plid = String(data["plid"])
    self.toUserName = data["toUserName"].string
    self.lastUserId = data["lastUserId"].string
    self.lastSummary = data["lastSummary"].string
    self.toUserAvatar = data["toUserAvatar"].string
    self.lastDateline = data["lastDateline"].string
    self.isNew = String(data["isNew"])
    self.pmid = String(data["pmid"])
    self.toUserId = String(data["toUserId"])
    
  }
}
