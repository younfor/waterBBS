//
//  MsgTableViewController.swift
//  waterbbs
//
//  Created by y on 15/12/28.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class MsgTableViewController: UITableViewController {
  
  let cell_header = "cell_header"
  let cell_content = "cell_content"
  var msgGroups = Array<MessageGroup>()
  var curPage = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // 设置白色标题
    self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 1/255.0, green: 131/255.0, blue: 230/255.0, alpha: 1))
    self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    self.tableView.tableFooterView = UIView()
    // 注册
    self.tableView.registerNib(UINib.init(nibName: "MsgGroupHeaderCell", bundle: nil), forCellReuseIdentifier: self.cell_header)
    self.tableView.registerNib(UINib.init(nibName: "MsgGroupContentCell", bundle: nil), forCellReuseIdentifier: self.cell_content)
    self.tableView.rowHeight = 68
    self.loadData()
  }
  /**
   加载网络数据
   */
  func loadData() {
    HttpTool.getHttpTool().msgGroup(self.curPage, onSuccess: { (data) -> Void in
      self.msgGroups.removeAll()
      self.msgGroups.appendContentsOf(data)
      self.tableView.reloadData()
      }) { (error) -> Void in
        print(error)
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.msgGroups.count + 3
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.row < 3 {
      let cell = tableView.dequeueReusableCellWithIdentifier(self.cell_header) as! MsgGroupHeaderCell
      cell.setData(indexPath.row)
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier(self.cell_content) as! MsgGroupContentCell
      cell.setData(self.msgGroups[indexPath.row - 3])
      return cell
    }
  
  }

  
}
