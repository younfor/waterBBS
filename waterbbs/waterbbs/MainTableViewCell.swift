//
//  MainTableViewCell.swift
//  waterbbs
//
//  Created by y on 15/12/17.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
  @IBOutlet weak var picWidth: NSLayoutConstraint!

  @IBOutlet weak var pic: UIImageView!
  @IBOutlet weak var count: UILabel!
  @IBOutlet weak var time: UILabel!
  @IBOutlet weak var topicname: UILabel!
  
  @IBOutlet weak var topicDescripe: UILabel!
  
  func setData(topic:Topic) {
    // 计算时间
    let dateString = topic.last_reply_date as NSString
    let num = dateString.doubleValue/1000
    let date = NSDate.init(timeIntervalSince1970: num)
    self.time.text = date.prettyDateWithReference(NSDate.init(timeIntervalSinceNow: 0))
    if (self.time.text?.containsString("分钟")==true) || (self.time.text?.containsString("刚刚")==true)  {
      self.time.textColor = UIColor.orangeColor()
    } else {
      self.time.textColor = UIColor.grayColor()
    }
    self.count.text = "\(topic.user_nick_name)  人气 \(topic.hits)°"
    //删除前缀
    let range = topic.title.rangeOfString("]")
    self.topicname.text = topic.title.substringFromIndex((range?.startIndex.advancedBy(1))!)
    self.topicDescripe.text = topic.subject
    let url = topic.pic_path
    if url != "" {
      self.pic.sd_setImageWithURL(NSURL.init(string:url!))
      //print("有图")
    } else {
      picWidth.constant = 0
      setNeedsUpdateConstraints()
    }

  }

}
