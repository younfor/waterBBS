
//
//  MsgGroupContentCell.swift
//  waterbbs
//
//  Created by y on 15/12/28.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class MsgGroupContentCell: UITableViewCell {
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var descLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imgView: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func setData(msg:MessageGroup) {
    self.titleLabel.text = msg.toUserName
    self.descLabel.text = msg.lastSummary
    self.imgView.sd_setImageWithURL(NSURL.init(string: msg.toUserAvatar!))
    // 计算时间
    let dateString = msg.lastDateline! as NSString
    let num = dateString.doubleValue/1000
    let date = NSDate.init(timeIntervalSince1970: num)
    self.dateLabel.text = date.prettyDateWithReference(NSDate.init(timeIntervalSinceNow: 0))
  }
  
}
