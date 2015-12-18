//
//  SideMenuViewController.swift
//  waterbbs
//
//  Created by y on 15/12/14.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

  @IBOutlet weak var tableview: UITableView!
  @IBOutlet weak var userLabel: UILabel!
  @IBOutlet weak var headImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
      print("显示侧边栏")
      // 加载头像
      if User.getUser().load() {
        self.userLabel.text = User.getUser().userName
        self.headImage.sd_setImageWithURL(NSURL.init(string: User.getUser().avatar!))
      } else {
        self.userLabel.text = "未登录"
      }
    }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
  }
}
