//
//  SideMenuViewController.swift
//  waterbbs
//
//  Created by y on 15/12/14.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
