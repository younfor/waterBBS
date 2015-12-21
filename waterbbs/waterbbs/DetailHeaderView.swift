//
//  DetailHeaderView.swift
//  waterbbs
//
//  Created by y on 15/12/21.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class DetailHeaderView: UIView {

  @IBOutlet weak var icon: UIImageView!
  
  @IBOutlet weak var topicTitle: UILabel!

  @IBOutlet weak var userNick: UILabel!
  
  @IBOutlet weak var level: UILabel!
  
  @IBOutlet weak var mobileFrom: UILabel!
  
  func setData(data:TopicDetail) {
    /*
    var page:String?
    var has_next:String?
    var total_num:String?
    var reply_list = Array<Reply>()
    // topic
    var title:String?
    var topic_id:String?
    var mobileSign:String? //来自安卓或者iOS
    var create_date:String?
    var level:String?
    var icon:String?
    var userTitle:String?
    // content
    var infor:String?
    var type:String?*/
    self.icon.sd_setImageWithURL(NSURL.init(string: data.icon!))
    self.topicTitle.text = data.title!
    self.userNick.text = data.user_nick_name!
    self.level.text = "\(data.userTitle!)"
    // 计算时间
    if let mobile = data.mobileSign {
      self.mobileFrom.text = "\(mobile) \(self.time(data.create_date!))"
    } else {
      self.mobileFrom.text = "\(self.time(data.create_date!))"
    }
    
  }
  func time(data:String) -> String {
    // 计算时间
    let dateString = data as NSString
    let num = dateString.doubleValue/1000
    let date = NSDate.init(timeIntervalSince1970: num)
    return date.prettyDateWithReference(NSDate.init(timeIntervalSinceNow: 0))
  }
}
