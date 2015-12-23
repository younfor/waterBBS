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
  var height:CGFloat?
  func setData(data:TopicDetail) {

    if let url = data.icon {
      self.icon.sd_setImageWithURL(NSURL.init(string: url))
    }
    self.topicTitle.text = data.title!
    self.userNick.text = data.user_nick_name!
    self.level.text = "\(data.userTitle!)"
    // 计算时间
    self.mobileFrom.text = "\(self.time(data.create_date!))"
    // 主要内容
    self.content(data.infors!)
    // 调整高度
    self.textView.frame = CGRectMake(8, 95, self.textView.frame.width, self.textView!.contentSize.height)
    self.height = CGRectGetMaxY(self.textView.frame)
    
  }
  func content(data:[String:String]) {
    var pics = Array<String>()
    for (type,text) in data {
      print(type)
      print(text)
      if type == "1" {
        // 大图片
        pics.append(text)
      } else if type == "0" {
        // 文本
        // 找出表情链接
        var picContent = text
        for _ in 0..<Int.max {
          let range = picContent.rangeOfString("[mobcent_phiz=")
          if range == nil {
            // 插入内容
            self.insertText(picContent)
            break
          } else {
            let endRange = picContent.rangeOfString("]")
            let picRange = Range(start: range!.endIndex, end: endRange!.startIndex)
            // 插入内容
            let content = picContent.substringToIndex(range!.startIndex)
            self.insertText(content)
            // 链接
            let picUrl = picContent.substringWithRange(picRange)
            self.insertImage(UIImage.init(data: NSData.init(contentsOfURL: NSURL.init(string: picUrl)!)!))
            // 截取
            picContent = picContent.substringFromIndex(endRange!.endIndex)
          }
        }
      }
    }
  }
  func insertImage(img:UIImage?) {
    // 图片转为富文本
    let att = NSTextAttachment()
    att.image = img//UIImage.init(named: "TopImage4")
    att.bounds = CGRectMake(0, 0, 32, 32)
    let attStr = NSAttributedString(attachment: att)
    // 初始化富文本
    let mutableStr = NSMutableAttributedString(attributedString: self.textView.attributedText)
    // 插入
    mutableStr.insertAttributedString(attStr, atIndex: self.textView.selectedRange.location)
    self.textView.attributedText = mutableStr
    self.textView.selectedRange = NSMakeRange(self.textView.selectedRange.location+1, 0)
  }
  func insertText(data:String) {
    // 初始化富文本
    let mutableStr = NSMutableAttributedString(attributedString: self.textView.attributedText)
    mutableStr.insertAttributedString(NSAttributedString.init(string: data), atIndex: self.textView.selectedRange.location)
    mutableStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0,mutableStr.length))
    mutableStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(15), range: NSMakeRange(0,mutableStr.length))
    self.textView.attributedText = mutableStr
    self.textView.selectedRange = NSMakeRange(self.textView.selectedRange.location+1, 0)
  }

  func time(data:String) -> String {
    // 计算时间
    let dateString = data as NSString
    let num = dateString.doubleValue/1000
    let date = NSDate.init(timeIntervalSince1970: num)
    return date.prettyDateWithReference(NSDate.init(timeIntervalSinceNow: 0))
  }
}
