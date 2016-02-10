//
//  DetailHeaderView.swift
//  waterbbs
//
//  Created by y on 15/12/21.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit
import SwiftyJSON
class DetailHeaderView: UIView {

  @IBOutlet weak var icon: UIImageView!
  
  @IBOutlet weak var topicTitle: UILabel!

  @IBOutlet weak var userNick: UILabel!
  
  @IBOutlet weak var level: UILabel!
  
  @IBOutlet weak var mobileFrom: UILabel!
  
  @IBOutlet weak var textView: UITextView!
  
  var pics = Array<String>()
  var height:CGFloat?
  func setData(data:TopicDetail) {
    
    if let url = data.icon {
      self.icon.sd_setImageWithURL(NSURL.init(string: url))
    }
    if data.title == nil {
      // 访问未登录数据
      User.getUser().showLogin()
      return
    }
    self.topicTitle.text = data.title!
    self.userNick.text = data.user_nick_name!
    self.level.text = "\(data.userTitle!)"
    // 计算时间
    self.mobileFrom.text = "\(self.time(data.create_date!))"
    // 主要内容
    self.textView.text = ""
    for data in data.infors! {
      self.content(data)
    }
    // 调整高度
    self.textView.frame = CGRectMake(8, 95, self.textView.frame.width, self.textView!.heightForContent())
    self.height = CGRectGetMaxY(self.textView.frame) + 28
    self.textView.userInteractionEnabled = false

    
  }
  func content(data:[String:String]) {
    let type = data["type"]!
    let text = data["infor"]!
      if type == "1" {
        self.insertImage(UIImage.init(),big: true)
        // 插入大图
        let imgView = UIImageView.init(frame: CGRectMake(0, self.textView.heightForContent() - self.frame.width + 5 , self.frame.width, self.frame.width))
        imgView.sd_setImageWithURL(NSURL.init(string: text))
        self.textView.addSubview(imgView)
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
      else {
        self.insertText(text)
      }
  }
  func insertImage(img:UIImage?,big:Bool = false) {
    // 图片转为富文本
    let att = NSTextAttachment()
    att.image = img//UIImage.init(named: "TopImage4")
    if big {
      att.bounds = CGRectMake(0, 5, self.frame.width - 8, self.frame.width)
    } else {
      att.bounds = CGRectMake(0, 0, 32, 32)
    }
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
