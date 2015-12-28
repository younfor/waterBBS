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
  }
  
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.row < 3 {
      let cell = tableView.dequeueReusableCellWithIdentifier(self.cell_header) as! MsgGroupHeaderCell
      cell.setData(indexPath.row)
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier(self.cell_content) as! MsgGroupContentCell
      return cell
    }
  
  }

  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the specified item to be editable.
  return true
  }
  */
  
  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  if editingStyle == .Delete {
  // Delete the row from the data source
  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  } else if editingStyle == .Insert {
  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
  }
  */
  
  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
  
  }
  */
  
  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the item to be re-orderable.
  return true
  }
  */
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
