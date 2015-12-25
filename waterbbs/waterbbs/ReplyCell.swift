//
//  ReplyCell.swift
//  waterbbs
//
//  Created by y on 15/12/24.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit
import SnapKit

class ReplyCell: UITableViewCell {
  

  @IBOutlet weak var mainText: UITextView!
  
  @IBOutlet weak var replyText: UITextView!
  @IBOutlet weak var position: UILabel!
  @IBOutlet weak var time: UILabel!
  @IBOutlet weak var level: UILabel!
  @IBOutlet weak var icon: UIImageView!
  @IBOutlet weak var userTitle: UILabel!

  override func awakeFromNib() {
    self.mainText.translatesAutoresizingMaskIntoConstraints = false
    super.awakeFromNib()
    // Initialization code
  }
  func setData(reply:Reply) {
    // 设置
    self.userTitle.text = reply.reply_name
    self.icon.sd_setImageWithURL(NSURL.init(string: reply.icon!))
    self.level.text = reply.userTitle!
    // time
    self.time.text = self.time(reply.posts_date!)
    self.position.text = "\(reply.position!)楼 "
    self.replyText.text = ""
    self.mainText.text = ""
    // 主要内容
    for sub in self.mainText.subviews {
      if sub.isKindOfClass(NSClassFromString("UITextView")!) {
        sub.removeFromSuperview()
      }
    }
    for sub in self.replyText.subviews {
      if sub.isKindOfClass(NSClassFromString("UITextView")!) {
        sub.removeFromSuperview()
      }
    }
    self.mainText.addSubview(reply.mainTextView!)
    // 引用
    if reply.is_quote! == "1" {
      reply.quote_TextView?.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.3)
      self.replyText.addSubview(reply.quote_TextView!)
    }
    // 重置约束
    self.mainText.translatesAutoresizingMaskIntoConstraints = false
    self.mainText.snp_remakeConstraints { (make) -> Void in
      make.left.equalTo(self.contentView).offset(52)
      make.top.equalTo(self.contentView).offset(28)
      make.right.equalTo(self.contentView).offset(36)
      make.height.equalTo(reply.main_height!)
    }
    reply.mainTextView?.frame = CGRectMake(0, 0, reply.mainTextView!.frame.width, reply.main_height!)
    self.replyText.snp_remakeConstraints { (make) -> Void in
      if reply.is_quote! == "1" {
        make.left.equalTo(self.contentView).offset(52)
        make.top.equalTo(self.mainText.snp_bottom).offset(2)
        make.right.equalTo(self.contentView).offset(36)
        make.height.equalTo(reply.quote_height!)
      }
    }
    if reply.is_quote! == "1" {
      reply.quote_TextView?.frame = CGRectMake(0, 0, reply.quote_TextView!.frame.width, reply.quote_height!)
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
