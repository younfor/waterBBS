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
  
  @IBOutlet weak var refreshIndicator: UIActivityIndicatorView!
  // 刷新控件
  var refresh:ZJRefreshControl!
  // 当前页数
  var curPage = 1
  // 触摸
  var lastTouchY:CGFloat = 0
  // tababar
  var preIndex = 0
  // 轮播图片
  var topPicturesView :SDCycleScrollView!
  // top
  var topScrollView:UIScrollView!
  var topHeaderView:UIView!
  // tableview
  lazy var topics = Array<Topic>()
  lazy var topTopicIds = Array<String>()
  lazy var topForumIds = Array<String>()
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
    let BackBarButtonItem = UIBarButtonItem(title:"返回", style: .Plain, target: nil, action: nil)
    self.navigationItem.backBarButtonItem = BackBarButtonItem
    //self.titleTop.alpha = 0
    //创建leftBarButtonItem以及添加手势识别
    let leftButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .Plain, target: self.revealViewController(), action: "revealToggle:")
    leftButton.tintColor = UIColor.whiteColor()
    self.navigationItem.setLeftBarButtonItem(leftButton, animated: false)
    // tableview
    self.tableView.registerNib(UINib.init(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: self.cell)
    self.tableView.rowHeight = 80
    self.loadTopics(true)
    // footerview
    let footer = UILabel.init(frame: CGRectMake(0, 20, self.tableView.frame.width, 20))
    footer.text = "上拉会更多哦"
    footer.textAlignment = NSTextAlignment.Center
    footer.font = UIFont.systemFontOfSize(14)
    footer.textColor = UIColor.grayColor()
    self.tableView.tableFooterView = footer

    // 代理
    tabBarController?.delegate = self
    // 通知
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "mainReload:", name: "mainReload", object: nil)
  }
  func mainReload(noti:NSNotification) {
    let obj  = noti.object as! [String:String]
    MainViewController.forumID = obj["id"]!
    print("准备展示\(MainViewController.forumID)")
    self.preIndex = 0
    self.curPage = 1
    self.titleTop.text = obj["name"]!
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
    print(MainViewController.forumID)
    // 网络操作
    HttpTool.getHttpTool().topicList(MainViewController.forumID, page: self.curPage, onSuccess: { (datas) -> Void in
      // 更新表
      if clear {
        self.topics.removeAll()
        print("缓存数据库")
        DBManager.DBAddTitleList(datas)
      }
      self.topics.appendContentsOf(datas)
      self.tableView.reloadData()
      if clear {
        self.refreshIndicator.stopAnimating()
        self.tableView.contentOffset = CGPointMake(0, 0)
      } else {
        self.refreshIndicator.stopAnimating()
      }
      
      // 更新head
      var pics = Array<String>()
      var titles = Array<String>()
      self.topTopicIds.removeAll()
      self.topForumIds.removeAll()
      // 最新图片-最大6张
      var i = 0
      for topic:Topic in datas {
        if topic.isPicTopic() {
          pics.append(topic.pic_path!)
          titles.append(topic.title)
          self.topTopicIds.append(topic.topic_id!)
          self.topForumIds.append(topic.board_id!)
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

    topHeaderView = UIView.init(frame: CGRectMake(0, 0, topPicturesView.frame.width, topPicturesView.frame.height))
    topScrollView = UIScrollView.init(frame: topHeaderView.bounds)
    topScrollView.addSubview(topPicturesView)
    topHeaderView.addSubview(topScrollView)
    //设置内容层的自动布局并存储
    topPicturesView.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin,UIViewAutoresizing.FlexibleRightMargin,UIViewAutoresizing.FlexibleTopMargin,UIViewAutoresizing.FlexibleBottomMargin,UIViewAutoresizing.FlexibleHeight,UIViewAutoresizing.FlexibleWidth]
    tableView.tableHeaderView = topHeaderView
  }
  
  // 轮播图片选中代理
  func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("detailVC") as! DetailViewController
    vc.topicId = topTopicIds[index]//
    vc.forumId = topForumIds[index]
    self.navigationController?.pushViewController(vc, animated: true)
    print("选中\(index)")
  }
  let ktopHeight:CGFloat = 154
  // 滚动代理
  override func scrollViewDidScroll(scrollView: UIScrollView) {
    //防止越界
    if scrollView.contentOffset.y < -60 {
      scrollView.contentOffset.y = -60
      if refreshIndicator.isAnimating() == false {
        refreshIndicator.startAnimating()
        curPage = 1
        loadTopics(true)
      }
    }
    //Parallax效果
    let header = self.tableView.tableHeaderView!
    let y = scrollView.contentOffset.y
    var f = header.frame
    if (y<0) {
      let delta = fabs(min(y, 0))
      f.origin.y -= delta
      f.size.height += delta
      topScrollView.frame = f
      topHeaderView.clipsToBounds = false
    } else {
      topHeaderView.clipsToBounds = true
    }
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
//    if offsetY > 0 && lastTouchY - offsetY < 0  {
//      self.tabBarController?.tabBar.alpha = 0
//    } else {
//      self.tabBarController?.tabBar.alpha = 1
//    }
//    lastTouchY = offsetY
    
  }
  // tableview
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.topics.count
  }
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell:MainTableViewCell = tableView.dequeueReusableCellWithIdentifier(self.cell) as! MainTableViewCell
    cell.setData(self.topics[indexPath.row])
    if (indexPath.row == self.topics.count - 1) && (self.refreshIndicator.isAnimating() == false){
      self.loadMore()
      
    }
    return cell
  }
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let topic = self.topics[indexPath.row]
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("detailVC") as! DetailViewController
    vc.topicId = topic.topic_id
    vc.forumId = topic.board_id
    if topic.sourceWebUrl != nil {
      print(topic.sourceWebUrl)
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
// MARK - delegate
extension MainViewController: UITabBarControllerDelegate {
  func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
    if (self.tabBarController?.selectedIndex == preIndex) {
      
      MainViewController.forumID = ""
      curPage = 1
      self.titleTop.text = "首页"
      
      refreshIndicator.startAnimating()
      self.loadTopics(true)
    }
    preIndex = (self.tabBarController?.selectedIndex)!
  }
}
