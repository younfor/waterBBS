//
//  DetailViewController.swift
//  waterbbs
//
//  Created by y on 15/12/21.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var tableview: UITableView!
  var topicId:String?
  var forumId:String?
  weak var header:DetailHeaderView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // 设置白色标题
    self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 1/255.0, green: 131/255.0, blue: 230/255.0, alpha: 1))
    self.automaticallyAdjustsScrollViewInsets = false
    // 加载网络数据
    self.loadData()
    // 头部
    self.header = NSBundle.mainBundle().loadNibNamed("DetailHeadeView", owner: nil, options: nil).first as? DetailHeaderView
    //self.header?.frame = CGRectMake(0, 0, 300, 200)
    self.tableview.tableHeaderView = self.header
    //
  }
  
  func loadData() {
    HttpTool.getHttpTool().topicDetail(self.topicId!, page: 1, onSuccess: { (data) -> Void in
        self.header!.setData(data)
      }) { (error) -> Void in
        print(error)
    }
  }
  
}
