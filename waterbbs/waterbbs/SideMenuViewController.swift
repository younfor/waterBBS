//
//  SideMenuViewController.swift
//  waterbbs
//
//  Created by y on 15/12/14.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
  @IBOutlet weak var tableview: UITableView!
  @IBOutlet weak var userLabel: UILabel!
  @IBOutlet weak var headImage: UIImageView!
  
  @IBOutlet weak var login: UIButton!
  
  @IBAction func onLogin(sender: AnyObject) {
    if User.getUser().load() == false {
      User.getUser().showLogin()
      login.setTitle("登陆", forState: UIControlState.Normal)
    } else {
      User.getUser().clear()
      self.headImage.image = UIImage()
      self.userLabel.text = ""
      login.setTitle("退出", forState: UIControlState.Normal)
    }
  }
  // 数据
  lazy var forums = DBManager.DBGroupListWithCollected()
  let cell = "sideCell"
  override func viewDidLoad() {
    super.viewDidLoad()
    print("显示侧边栏")
    self.tableview.delegate = self
    self.tableview.dataSource = self
    // 加载头像
    if User.getUser().load() {
      self.userLabel.text = User.getUser().userName
      self.headImage.sd_setImageWithURL(NSURL.init(string: User.getUser().avatar!))
      login.setTitle("退出", forState: UIControlState.Normal)
    } else {
      self.userLabel.text = "未登录"
      login.setTitle("登陆", forState: UIControlState.Normal)
    }
    // 接收更新通知
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "sideReload", name: "sideReload", object: nil)
    // 登陆按钮设置
    
  }
  // notify
  func sideReload() {
    print("side notify")
    self.forums = DBManager.DBGroupListWithCollected()
    self.tableview.reloadData()
  }
  // tableview
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let board_id = self.forums[indexPath.row].board_id
    print("选中\(board_id)")
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.forums.count
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(self.cell)
    cell?.textLabel?.text = self.forums[indexPath.row].board_name
    cell?.textLabel?.textAlignment = NSTextAlignment.Center
    return cell!
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let group = self.forums[(self.tableview.indexPathForSelectedRow?.row)!]
    MainViewController.forumID = group.board_id!
  }
}
