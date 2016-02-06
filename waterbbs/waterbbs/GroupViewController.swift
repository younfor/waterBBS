//
//  GroupViewController.swift
//  waterbbs
//
//  Created by y on 15/12/18.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class GroupViewController: UITableViewController {

  lazy var forums = Array<Forum>()
  var oldForums:Array<Forum>?
  let cell = "groupCell"
  // 是否编辑
  var isEdit = false
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setRightButtonItem()
    self.setLeftButtnItem()
    // 设置透明NavBar
    self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 1/255.0, green: 131/255.0, blue: 230/255.0, alpha: 1))
    self.navigationController?.navigationBar.shadowImage = UIImage()
    // 设置白色标题
    self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    // 首先读取数据库
    let groups = DBManager.DBGroupList()
    print(groups?.count)
    self.forums = Forum.DBForumList(groups!)
    self.tableView.reloadData()
    // 加载网络数据
    HttpTool.getHttpTool().forumList({ (data) -> Void in
      // 更新数据库
      DBManager.DBAddGroupList(data)
      self.forums = Forum.DBForumList(DBManager.DBGroupList()!)
      self.tableView.reloadData()
      
      }) { (error) -> Void in
        print(error)
    }
  }
  // 设置导航右边管理按钮
  func setRightButtonItem(){
    var title = "编辑"
    if self.isEdit {
      title = "收藏"
    } else {
      title = "编辑"
    }
    let barButtonItem = UIBarButtonItem(title:title, style: .Done, target: self, action: "onRightClick")
    barButtonItem.tintColor = UIColor.whiteColor()
    self.navigationItem.rightBarButtonItem = barButtonItem
  }
  // 设置左边取消按钮
  func setLeftButtnItem() {
    var title = "取消"
    if self.isEdit {
      title = "取消"
    } else {
      title = ""
    }
    let barButtonItem = UIBarButtonItem(title:title, style: .Done, target: self, action: "onLeftClick")
    barButtonItem.tintColor = UIColor.whiteColor()
    self.navigationItem.leftBarButtonItem = barButtonItem
  }
  // 事件
  func onLeftClick() {
    if self.isEdit {
      print("取消收藏")
      self.forums = Forum.DBForumList(DBManager.DBGroupList()!)
      self.tableView.reloadData()
    }
    self.isEdit = !self.isEdit
    self.setRightButtonItem()
    self.setLeftButtnItem()
  }
  func onRightClick() {
    if self.isEdit {
      print("加入数据库")
      // 更新数据库
      DBManager.DBAddGroupList(self.forums)
      // 通知侧栏更新
  NSNotificationCenter.defaultCenter().postNotificationName("sideReload", object: nil)
    
    } else {
      print("准备收藏")
      self.oldForums = Array(self.forums)
    }
    self.isEdit = !self.isEdit
    self.setRightButtonItem()
    self.setLeftButtnItem()
    
  }
  // tableview
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.forums[section].board_list!.count
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    let child = self.forums[indexPath.section].board_list![indexPath.row]
    // 如何可编辑
    if self.isEdit {
      if cell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
        cell?.accessoryType = UITableViewCellAccessoryType.None
        child.isCollected = NSNumber.init(bool: false)
      } else {
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        child.isCollected = NSNumber.init(bool: true)
      }
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    } else {
      // 跳转到首页控制器
      self.tabBarController?.selectedIndex = 0
      NSNotificationCenter.defaultCenter().postNotificationName("mainReload", object: ["id":child.board_id,"name":child.board_name])
    }
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.forums.count
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.textAlignment = NSTextAlignment.Center
    label.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3)
    label.text = self.forums[section].board_category_name
    return label
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(self.cell)
    let child = self.forums[indexPath.section].board_list![indexPath.row]
    cell!.tag = (Int)(child.board_id)!
    cell!.textLabel?.text = child.board_name
    if child.td_posts_num != "0" {
      cell!.detailTextLabel?.text = "\(child.td_posts_num)°"
    } else {
      cell!.detailTextLabel?.text = ""
    }
    cell!.detailTextLabel?.transform = CGAffineTransformMakeTranslation(-20, 0)
    if child.isCollected?.boolValue == false {
      cell?.accessoryType = UITableViewCellAccessoryType.None
    } else {
      cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
      cell!.detailTextLabel?.text = ""
    }
    return cell!
  }

  
}
