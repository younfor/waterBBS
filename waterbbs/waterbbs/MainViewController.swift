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
    // 触摸
    var lastTouchY:CGFloat = 0
    // 轮播图片
    var topPicturesView :SDCycleScrollView!
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
        self.titleTop.alpha = 0
    }
    func initTopPicturesView() {
        // 初始化轮播图片
        self.topPicturesView = SDCycleScrollView(frame: CGRectMake(0, 0, self.tableView.frame.width, 154), imagesGroup: [UIImage.init(named: "TopImage1")!,UIImage.init(named: "TopImage2")!,UIImage.init(named: "TopImage3")!,UIImage.init(named: "TopImage4")!,UIImage.init(named: "TopImage5")!])
        self.topPicturesView.titlesGroup = ["你好吗","哈哈","测试啦","傻","去哪了"]
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
        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        
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
            self.titleTop.alpha = 0
        }
        //tabBar
        print("\(lastTouchY - offsetY),\(offsetY)")
        if offsetY > 0 && lastTouchY - offsetY < 0  {
            print("需要显示")
            self.tabBarController?.tabBar.alpha = 0
        } else {
            print("需要消失")
            self.tabBarController?.tabBar.alpha = 1
        }
        lastTouchY = offsetY
        
    }
    // tableview
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
     }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mainCell")!
        cell.textLabel?.text = "测试啊"
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
