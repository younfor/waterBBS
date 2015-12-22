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
  
  @IBOutlet weak var textView: UITextView!
  func setData(data:TopicDetail) {
    if let url = data.icon {
      self.icon.sd_setImageWithURL(NSURL.init(string: url))
    }
    self.topicTitle.text = data.title!
    self.userNick.text = data.user_nick_name!
    self.level.text = "\(data.userTitle!)"
    // 计算时间
    //if let mobile = data.mobileSign {
    //  self.mobileFrom.text = "\(mobile) \(self.time(data.create_date!))"
    //} else {
    self.mobileFrom.text = "\(self.time(data.create_date!))"
    //}
    // 主要内容
    self.content(data.infors!)
    
  }
  func content(data:[String:String]) {
    var pics = Array<String>()
    for (type,text) in data {
      print(type)
      print(text)
      if type == "1" {
        // 图片
        pics.append(text)
      } else if type == "0" {
        //文本
        self.textView.text.appendContentsOf(text)
      }
    }
    let att = NSTextAttachment()
    att.image = UIImage.init(named: "TopImage4")
    att.bounds = CGRectMake(0, -4, 20, 20)
    5         //将附件转成NSAttributedString类型的属性化文本
    let attStr = NSAttributedString(attachment: att)
    // 获取所有文本
    let mutableStr = NSMutableAttributedString(attributedString: self.textView.attributedText)
    let selectedRange = self.textView.selectedRange
    // 插入
    mutableStr.insertAttributedString(attStr, atIndex: selectedRange.location)
    mutableStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0,mutableStr.length))
    mutableStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(15), range: NSMakeRange(0,mutableStr.length))
    let newRange = NSMakeRange(selectedRange.location+1, 0)
    // 回复
    self.textView.attributedText = mutableStr
    self.textView.selectedRange = newRange
  }
  func time(data:String) -> String {
    // 计算时间
    let dateString = data as NSString
    let num = dateString.doubleValue/1000
    let date = NSDate.init(timeIntervalSince1970: num)
    return date.prettyDateWithReference(NSDate.init(timeIntervalSinceNow: 0))
  }
}
