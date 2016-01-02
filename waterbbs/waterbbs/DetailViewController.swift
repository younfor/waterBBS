//
//  DetailViewController.swift
//  waterbbs
//
//  Created by y on 15/12/21.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITableViewDataSource ,UITableViewDelegate{
  
  @IBOutlet weak var tableview: UITableView!
  var topicId:String?
  var forumId:String?
  let cell = "ReplyCell"
  weak var header:DetailHeaderView?
  var replys:[Reply] = [Reply]()

  override func viewDidLoad() {
    super.viewDidLoad()
    // tableview
    self.tableview.tableFooterView = UILabel()
    self.tableview.dataSource = self
    self.tableview.delegate = self
    self.tableview.registerNib(UINib.init(nibName: self.cell, bundle: nil), forCellReuseIdentifier: self.cell)
    // 设置白色标题
    self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 1/255.0, green: 131/255.0, blue: 230/255.0, alpha: 1))
    self.automaticallyAdjustsScrollViewInsets = false
    // 加载网络数据
    self.loadData()
    // 头部
    self.header = NSBundle.mainBundle().loadNibNamed("DetailHeadeView", owner: nil, options: nil).first as? DetailHeaderView
    self.tableview.tableHeaderView = self.header
    //
  }
  @IBOutlet weak var titleLabel: UILabel!
  func loadData() {
    HttpTool.getHttpTool().topicDetail(self.topicId!, page: 1, onSuccess: { (data) -> Void in
      // 设置头部
      self.titleLabel.text = data.forumName
      self.header!.setData(data)
      NSOperationQueue.mainQueue().addOperationWithBlock({  [unowned self] () -> Void in
        self.header?.frame = CGRectMake(0, 0, self.view.frame.width, self.header!.height!)
        self.tableview.tableHeaderView = self.header!
        })
      // 设置评论
      self.replys = data.reply_list
      print("\(self.replys.count)条评论")
      self.tableview.reloadData()
      }) { (error) -> Void in
        print(error)
    }
  }
  // tableview
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.replys.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell:ReplyCell = tableView.dequeueReusableCellWithIdentifier(self.cell)! as! ReplyCell
    cell.setData(self.replys[indexPath.row])
    
    return cell
  }
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let r = self.replys[indexPath.row]
    var quote_h:CGFloat = 0
    if r.quote_height != nil {
      quote_h = r.quote_height!
    }
    return quote_h + r.main_height! + 60
  }
}
