//
//  FoundTableViewController.swift
//  waterbbs
//
//  Created by y on 16/2/9.
//  Copyright © 2016年 younfor. All rights reserved.
//

import UIKit
import SDWebImage

class FoundTableViewController: UITableViewController {
  
  @IBOutlet weak var login: UIButton!
  
  @IBOutlet weak var cache: UILabel!
  
  @IBOutlet weak var version: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    // 设置透明NavBar
    self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 1/255.0, green: 131/255.0, blue: 230/255.0, alpha: 1))
    self.navigationController?.navigationBar.shadowImage = UIImage()
    // 设置白色标题
    self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    // 设置按钮
    if User.getUser().load() {
      login.setTitle("退出", forState: UIControlState.Normal)
    } else {
      login.setTitle("登陆", forState: UIControlState.Normal)
    }
    // 设置缓存和版本号
    version.text = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as? String
    cache.text = "\(SDImageCache.sharedImageCache().getSize()/1024/1024)MB"
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    print(indexPath.section)
    print(indexPath.row)
    if (indexPath.section == 0 && indexPath.row == 0) {
      // 清除缓存
      SDImageCache.sharedImageCache().clearDisk()
      cache.text = "\(SDImageCache.sharedImageCache().getSize()/1024/1024)MB"
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
      // 关于
      UIAlertView.init(title: "", message: "Copyright by younfor", delegate: self, cancelButtonTitle: "确定").show()
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
      // 退出/登陆
      if login.titleLabel?.text == "退出" {
        login.titleLabel?.text = "登陆"
        User.getUser().clear()
      } else {
        login.titleLabel?.text = "退出"
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("loginSB")
        self.presentViewController(vc!, animated: true, completion: nil)
        
      }
    }
    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}
