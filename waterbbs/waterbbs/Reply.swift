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
  var topic:String?
  var reply_id:String?
  // 存储引用富文本参数
  var quote_height:CGFloat?
  var quote_TextView:UITextView?
  // 存储富文本内容参数
  var infors:[[String:String]]?
  var main_height:CGFloat?
  var mainTextView:UITextView?
  init(data:JSON) {
    super.init()
    //print(data["reply_content"])
    self.position = String(data["position"])
    self.status = String(data["status"])
    self.title = data["title"].string
    self.icon = data["icon"].string
    self.reply_name = data["reply_name"].string
    self.title = data["title"].string
    self.userTitle = data["userTitle"].string
    self.level = String(data["level"])
    self.posts_date = data["posts_date"].string
    self.status = String(data["status"])
    self.is_quote = String(data["is_quote"])
    self.reply_id = String(data["reply_id"])
    self.infors = [[String:String]]()
    for content in data["reply_content"] {
      self.infors?.append(["infor":(content.1)["infor"].string!,"type":String((content.1)["type"])])
    }
    // 更新评论内容
    self.mainTextView = UITextView.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 70, 50))
    for data in self.infors! {
          self.content(self.mainTextView!,data: data)
    }
    // 更新高度
    self.main_height = self.mainTextView!.heightForContent() + 10
    // 更新引用
    if String(data["is_quote"]) == "1" {
      self.quote_TextView = UITextView.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width - 70, 50))
      self.insertText(self.quote_TextView!, data: data["quote_content"].string!)
      // 更新高度
      self.quote_height = self.quote_TextView!.heightForContent() + 10
    }
    
  }
  func content(textView:UITextView,data:[String:String]) {
    let type = data["type"]!
    let text = data["infor"]!
    if type == "1" {
      self.insertImage(textView,img: UIImage.init(),big: true)
      // 插入大图
      let imgView = UIImageView.init(frame: CGRectMake(0, textView.heightForContent() - UIScreen.mainScreen().bounds.width + 5, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.width))
      imgView.sd_setImageWithURL(NSURL.init(string: text))
      textView.addSubview(imgView)
    } else if type == "0" {
      // 文本
      // 找出表情链接
      var picContent = text
      for _ in 0..<Int.max {
        let range = picContent.rangeOfString("[mobcent_phiz=")
        if range == nil {
          // 插入内容
          self.insertText(textView,data: picContent)
          break
        } else {
          let endRange = picContent.rangeOfString("]")
          let picRange = Range(start: range!.endIndex, end: endRange!.startIndex)
          // 插入内容
          let content = picContent.substringToIndex(range!.startIndex)
          self.insertText(textView,data: content)
          // 链接
          let picUrl = picContent.substringWithRange(picRange)
          self.insertImage(textView,img: UIImage.init(data: NSData.init(contentsOfURL: NSURL.init(string: picUrl)!)!))
          // 截取
          picContent = picContent.substringFromIndex(endRange!.endIndex)
        }
      }
    }
    else {
      self.insertText(textView,data: text)
    }
  }
  func insertImage(textView:UITextView,img:UIImage?,big:Bool = false) {
    // 图片转为富文本
    let att = NSTextAttachment()
    att.image = img//UIImage.init(named: "TopImage4")
    if big {
      att.bounds = CGRectMake(0, 5, UIScreen.mainScreen().bounds.width - 48, UIScreen.mainScreen().bounds.width)
    } else {
      att.bounds = CGRectMake(0, 0, 32, 32)
    }
    let attStr = NSAttributedString(attachment: att)
    // 初始化富文本
    let mutableStr = NSMutableAttributedString(attributedString: textView.attributedText)
    // 插入
    mutableStr.insertAttributedString(attStr, atIndex: textView.selectedRange.location)
    textView.attributedText = mutableStr
    textView.selectedRange = NSMakeRange(textView.selectedRange.location+1, 0)
  }
  func insertText(textView:UITextView,data:String) {
    // 初始化富文本
    let mutableStr = NSMutableAttributedString(attributedString: textView.attributedText)
    mutableStr.insertAttributedString(NSAttributedString.init(string: data), atIndex: textView.selectedRange.location)
    mutableStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0,mutableStr.length))
    mutableStr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(15), range: NSMakeRange(0,mutableStr.length))
    textView.attributedText = mutableStr
    textView.selectedRange = NSMakeRange(textView.selectedRange.location+1, 0)
  }

}
