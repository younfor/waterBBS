//
//  MainViewController.swift
//  waterbbs
//
//  Created by y on 15/12/12.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController,SDCycleScrollViewDelegate, ParallaxHeaderViewDelegate,UIGestureRecognizerDelegate {
  
  @IBOutlet weak var titleTop: UILabel!
  // 当前页数
  var curPage = 1
  // 触摸
  var lastTouchY:CGFloat = 0
  // 轮播图片
  var topPicturesView :SDCycleScrollView!
  // tableview
  lazy var topics = Array<Topic>()
  static var forumID = ""
  let cell = "mainCell"
  override func viewDidLoad() {
    super.viewDidLoad()
    self.automaticallyAdjustsScrollViewInsets = false
    // 设置顶部动图
    self.initTopPicturesView()
    // 设置透明NavBar
    self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
    self.navigationController?.navigationBar.shadowImage = UIImage()
    // 设置白色标题
    self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    //self.titleTop.alpha = 0
    //创建leftBarButtonItem以及添加手势识别
    let leftButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self.revealViewController(), action: "revealToggle:")
    leftButton.tintColor = UIColor.whiteColor()
    self.navigationItem.setLeftBarButtonItem(leftButton, animated: false)
    // tableview
    self.tableView.registerNib(UINib.init(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: self.cell)
    self.tableView.rowHeight = 80
    self.loadTopics(true)
    // 收到通知
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "mainReload:", name: "mainReload", object: nil)
  }
  func mainReload(noti:NSNotification) {
    MainViewController.forumID = noti.object as! String
    print("准备展示\(MainViewController.forumID)")
    self.loadTopics(true)
  }
  // 上拉加载更多
  func loadMore() {
    self.curPage++
    self.loadTopics(false)
  }
  func loadTopics(clear:Bool) {
    print("加载首页数据库数据")
    if self.curPage == 1 {
      if let titles = DBManager.DBTitleList() {
        self.topics = titles
      } else {
        print("数据库没有首页信息")
      }
    }
    // 网络操作
    HttpTool.getHttpTool().topicList(MainViewController.forumID, page: self.curPage, onSuccess: { (datas) -> Void in
      // 最新主题
      if clear {
        self.topics.removeAll()
      }
      self.topics.appendContentsOf(datas)
      print("缓存数据库")
      DBManager.DBAddTitleList(datas)
      self.tableView.reloadData()
      var pics = Array<String>()
      var titles = Array<String>()
      // 最新图片-最大6张
      var i = 0
      for topic:Topic in datas {
        if topic.isPicTopic() {
          pics.append(topic.pic_path!)
          titles.append(topic.title)
        }
        if i++ > 6 {
          break
        }
      }
      if titles.count == 0 {
        self.topPicturesView.titlesGroup = ["清水河畔"]
        self.topPicturesView.localizationImagesGroup = [UIImage.init(named: "TopImage3")!]
      } else {
        self.topPicturesView.titlesGroup = titles
        self.topPicturesView.imageURLStringsGroup = pics
      }
      }) { (error) -> Void in
        print(error)
    }
  }
  func initTopPicturesView() {
    // 初始化轮播图片
    self.topPicturesView = SDCycleScrollView(frame: CGRectMake(0, 0, self.tableView.frame.width, 154), imagesGroup: nil)
    self.topPicturesView.titleLabelBackgroundColor = UIColor.clearColor()
    self.topPicturesView.delegate = self
    self.topPicturesView.titleLabelAlpha = 1
    self.topPicturesView.titleLabelTextFont = UIFont(name: "STHeitiSC-Medium", size: 21)
    self.topPicturesView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic
    // 添加拉伸特效
    print(self.topPicturesView.frame.height)
    let headerSubview: ParallaxHeaderView = ParallaxHeaderView.parallaxHeaderViewWithSubView(self.topPicturesView, forSize: CGSizeMake(self.tableView.frame.width, self.topPicturesView.frame.height)) as! ParallaxHeaderView
    headerSubview.delegate  = self
    self.tableView.tableHeaderView = headerSubview
  }
  
  // 轮播图片选中代理
  func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
    print("选中\(index)")
  }
  // 滚动代理
  override func scrollViewDidScroll(scrollView: UIScrollView) {
    //防止越界
    if scrollView.contentOffset.y < -100 {
      scrollView.contentOffset.y = -100
    }
    //Parallax效果
    let header = self.tableView.tableHeaderView as! ParallaxHeaderView
    //header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
    
    //NavBar及titleLabel透明度渐变
    let color = UIColor(red: 1/255.0, green: 131/255.0, blue: 230/255.0, alpha: 1)
    let offsetY = scrollView.contentOffset.y
    let prelude: CGFloat = 90
    if offsetY > header.frame.height - 64 {
      let alpha = min(1, (offsetY - (header.frame.height - 64)) / (prelude))
      // titleLabel透明度渐变
      self.titleTop.alpha = alpha
      // NavBar透明度渐变
      self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
    } else if offsetY < -header.frame.height {
      return
    } else {
      self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
      self.titleTop.alpha = 1
    }
    //tabBar
    if offsetY > 0 && lastTouchY - offsetY < 0  {
      self.tabBarController?.tabBar.alpha = 0
    } else {
      self.tabBarController?.tabBar.alpha = 1
    }
    lastTouchY = offsetY
    
  }
  // tableview
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.topics.count
  }
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell:MainTableViewCell = tableView.dequeueReusableCellWithIdentifier(self.cell) as! MainTableViewCell
    cell.setData(self.topics[indexPath.row])
    return cell
  }
  
  
}
