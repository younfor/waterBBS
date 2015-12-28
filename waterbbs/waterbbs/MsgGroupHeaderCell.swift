//
//  MsgGroupHeaderCell.swift
//  waterbbs
//
//  Created by y on 15/12/28.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class MsgGroupHeaderCell: UITableViewCell {

  @IBOutlet weak var imgView: UIImageView!

  @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  func setData(flag:Int) {
    var title = ""
    if flag == 0 {
      self.imgView.image = UIImage.init(named: "message_at")
      title = "提到我的"
    } else if flag == 1 {
      self.imgView.image = UIImage.init(named: "message_comment")
      title = "评论我的"
    } else {
      self.imgView.image = UIImage.init(named: "message_add")
      title = "新申请好友"
    }
    self.titleLabel.text = title

  }
}
