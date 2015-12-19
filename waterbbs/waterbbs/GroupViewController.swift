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
  let cell = "groupCell"
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setRightDeleteButtonItem()
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
      self.forums = data
      self.tableView.reloadData()
      // 更新数据库
      DBManager.DBAddGroupList(data)
            }) { (error) -> Void in
        print(error)
    }
    self.tableView.setEditing(false, animated: true);
  }
  //设置导航右边管理按钮
  func setRightDeleteButtonItem(){
    
    let barButtonItem = UIBarButtonItem(title:"收藏", style: .Done, target: self, action: "showCollection")
    barButtonItem.tintColor = UIColor.whiteColor()
    self.navigationItem.rightBarButtonItem = barButtonItem
  }
  
  func showCollection() {
    print("开启编辑")
  }
  
  // tableview
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.forums[section].board_list!.count
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    let child = self.forums[indexPath.section].board_list![indexPath.row]
    if cell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
      cell?.accessoryType = UITableViewCellAccessoryType.None
      child.isCollected = NSNumber.init(bool: false)
    } else {
      cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
      child.isCollected = NSNumber.init(bool: true)
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
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
    if child.isCollected?.boolValue == false {
      cell?.accessoryType = UITableViewCellAccessoryType.None
    } else {
      cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    return cell!
  }

  
}
