//
//  HttpTool.swift
//  waterbbs
//
//  Created by y on 15/12/13.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// 主要处理网络后台接口数据调用的
class HttpTool: NSObject {
    // 一些公共参数
  let pageSize = 20
    var accessToken:String! = "b72642d1ab2825cafcda5bd23027e"
    var accessSecret:String! = "7f55871fbbe423200ef1890910610"
    var avatar:String!
    let baseUrl = "http://bbs.uestc.edu.cn/mobcent/app/web/index.php?r="
    let loginUrl = "user/login&&type=login"
    let logoutUrl = "user/login&&type=logout"
    let atuserUrl = "forum/atuserlist"
    let topicPicUrl = "forum/photogallery"
    let forumUrl = "forum/forumlist"
  let topicUrl = "forum/topiclist"
    // 一些私人参数
  let myboardId = "61"
    // 单例
    static let httpTool = HttpTool()
    class func getHttpTool() -> HttpTool {
        return httpTool
    }
  // 获取主题列表-(登陆/不登陆)
  func topicList(boardId:String,page:Int,onSuccess:(([Topic]) -> Void)?=nil, onFail:((String) -> Void)?=nil) {
    self.httpPost(self.baseUrl + self.topicUrl, params: ["page":page,"boardId":boardId,"pageSize":self.pageSize], withLogin: true, onSuccess: { (data) -> () in
      var topics:Array = Array<Topic>()
      for topicdata in data["list"] {
        topics.append(Topic.init(data: topicdata.1))
      }
      onSuccess?(topics)
      }) { (error) -> () in
        onFail?("请求失败:" + error)
    }
  }
    // 获取板块列表-(登陆/不登陆)
  func forumList(onSuccess:((forums:Array<Forum>) -> Void)?=nil, onFail:((String) -> Void)?=nil) {
    self.httpPost(self.baseUrl + self.forumUrl, params: [:], withLogin: true, onSuccess: { (data) -> () in
      var forums = Array<Forum>()
      for forum in data["list"] {
        let f = Forum.init(data: forum.1)
        forums.append(f)
      }
      onSuccess?(forums: forums)
      
      }) { (error) -> () in
        onFail?("请求失败:" + error)
    }
  }
  // 登陆
    func login(username:String,password:String,onSuccess:(() -> Void)?=nil, onFail:((String) -> Void)?=nil) {
        self.httpPost(self.baseUrl + self.loginUrl, params: ["username":username,"password":password], withLogin: false, onSuccess: { (data) -> () in
            print(data)
            // 存储用户数据
            User.getUser().accessToken = data["token"].string
            User.getUser().accessSecret = data["secret"].string
            User.getUser().userName = data["userName"].string
            User.getUser().avatar = data["avatar"].string
            guard User.getUser().save() else {
                print("存储用户失败")
                return
            }
            onSuccess?()
        }) { (error) -> () in
            onFail?("请求失败:" + error)
        }
    }
    // 登出
    func logout(username:String,password:String,onSuccess:(() -> Void)?=nil, onFail:((String) -> Void)?=nil) {
        self.httpPost(self.baseUrl + self.logoutUrl, params: ["username":username,"password":password], withLogin: false, onSuccess: { (data) -> () in
            print(data)
            onSuccess?()
            // 删除用户数据
            User.getUser().clear()
            }) { (error) -> () in
                onFail?("请求失败:" + error)
        }
    }
    // 测试
    func test() {
        //self.login("cq361106306", password: "199288")
        //self.atuserlist()
        //if User.getUser().load() == false {
        //    print("加载失败")
        //} else {
        //    print(User.getUser().userName)
        //}
      //self.topicPiclist()
      //self.topicList(self.myboardId, page: 1)

    }
    // 获取好友
    func atuserlist(onSuccess:(() -> Void)?=nil, onFail:((String) -> Void)?=nil) {
        self.httpPost(self.baseUrl + self.atuserUrl, params: [:], withLogin: true, onSuccess: { (data) -> () in
            print(data)
            onSuccess?()
            
        }) { (error) -> () in
            onFail?("请求失败:" + error)
        }
    }
    // 获取包含图片的帖子
    func topicPiclist(onSuccess:(() -> Void)?=nil, onFail:((String) -> Void)?=nil) {
      self.httpPost(self.baseUrl + self.topicPicUrl, params: ["page":1,"pageSize":10], withLogin: true, onSuccess: { (data) -> () in
        print(data)
        onSuccess?()
        
        }) { (error) -> () in
          onFail?("请求失败:" + error)
          print("失败")
      }
    }
    // 网络公共函数
    func httpPost(url:String, var params:[String:AnyObject], withLogin:Bool, onSuccess:(JSON) -> Void, onFail:(String) -> Void) {
        if withLogin {
            // 判断是否登录
            if !User.getUser().load() {
                print("尚未登陆，没有权限")
                return
            }
            params["accessToken"] = self.accessToken
            params["accessSecret"] = self.accessSecret
        }
        Alamofire.request(.POST, url, parameters: params, encoding: ParameterEncoding.URL, headers: nil).responseJSON { (res) -> Void in
            guard res.result.error == nil else {
                onFail(url)
                return
            }
            
            let data = NSString.init(data: res.data!, encoding: NSUTF8StringEncoding)
            let json = JSON.parse(data as! String)
            onSuccess(json)
        }
    }
    
}
