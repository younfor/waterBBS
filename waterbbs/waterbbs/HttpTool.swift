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
  let postUrl = "forum/postlist"
  let messageHeartUrl = "message/heart"
  let messageNotifyUrl = "message/notifylist"
  let messageListUrl = "message/pmlist"
  let messageSessionUrl = "message/pmsessionlist"
  let replyUrl = "forum/topicadmin"
  // 一些私人参数
  let myboardId = "61"
  // 单例
  static let httpTool = HttpTool()
  class func getHttpTool() -> HttpTool {
    return httpTool
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
    //self.msgGroup(1)
    
  }
  // 获取消息会话列表
  func msgGroup(page:Int,onSuccess:(([MessageGroup]) -> Void)?=nil, onFail:((String) -> Void)?=nil)  {
    
    let para = "[{page:\(page),pageSize:\(self.pageSize)}]"
    self.httpPost(self.baseUrl + self.messageSessionUrl, params: ["json":para], withLogin: true, onSuccess: { (data) -> () in
      var msgs = Array<MessageGroup>()
      for m in data["body"]["list"] {
        msgs.append(MessageGroup.init(data: m.1))
      }
      //print(data)
      onSuccess?(msgs)
      }) { (error) -> () in
        onFail?("请求失败:" + error)
    }
  }
  // 获取具体帖子信息
  func topicDetail(topicId:String,page:Int,onSuccess:((TopicDetail) -> Void)?=nil, onFail:((String) -> Void)?=nil) {
    self.httpPost(self.baseUrl + self.postUrl, params: ["page":page,"topicId":topicId,"pageSize":self.pageSize], withLogin: true, onSuccess: { (data) -> () in
      print(data)
      let topicdetail = TopicDetail(data: data)
      onSuccess?(topicdetail)
      }) { (error) -> () in
        onFail?("请求失败:" + error)
    }
  }
  
  // 获取主题列表-(登陆/不登陆)
  func topicList(boardId:String,page:Int,onSuccess:(([Topic]) -> Void)?=nil, onFail:((String) -> Void)?=nil) {
    self.httpPost(self.baseUrl + self.topicUrl, params: ["page":page,"boardId":boardId,"pageSize":self.pageSize], withLogin: true, onSuccess: { (data) -> () in
      var topics:Array = Array<Topic>()
      for topicdata in data["list"] {
        let topic = Topic.init(data: topicdata.1)
        if boardId == "" && self.isTooLate(topic.last_reply_date) {
          continue
        } else {
          topics.append(Topic.init(data: topicdata.1))
        }
      }
      onSuccess?(topics)
      }) { (error) -> () in
        onFail?("请求失败:" + error)
    }
  }
  // 判断时间是否太晚
  func isTooLate(date:String) -> Bool{
    let dateString = date as NSString
    let num = dateString.doubleValue/1000
    let date = NSDate.init(timeIntervalSince1970: num)
    let text = date.prettyDateWithReference(NSDate.init(timeIntervalSinceNow: 0))
    if text.containsString("年") || text.containsString("月") || text.containsString("周") {
      return true
    }
    return false
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
  // 回复帖子
  func replyTopic(data:[String:String],onSuccess:(() -> Void)?=nil, onFail:((String) -> Void)?=nil) {
    let fid = data["fid"]!//板块
    let tid = data["tid"]!//帖子
    let context = data["content"]!//内容
    //计算参数
    let date = NSDate.init(timeIntervalSinceNow: 0)
    let a = date.timeIntervalSince1970 * 1000
    let time = NSString.init(format: "%f", a)
    let authkey = "appbyme_key"
    let authString = time.substringWithRange(NSRange.init(location: 0, length: 5)) + authkey
    let hash = authString.md5 as NSString
    let str = hash.substringWithRange(NSRange.init(location: 8, length: 8))
    print(str)
    
    //NSData转换成NSString打印输出
    let hh = "{\"body\":{\"json\":{\"isHidden\":0,\"content\":\"[{\\\"type\\\":0,\\\"infor\\\":\\\"\(context)\\\"}]\",\"fid\":\(fid),\"isQuote\":0,\"isShowPostion\":0,\"location\":\"\",\"isOnlyAuthor\":0,\"longitude\":\"0.0\",\"latitude\":\"0.0\",\"aid\":\"\",\"tid\":\(tid),\"replyId\":0,\"isAnonymous\":0}}}"
    let session = NSURLSession.sharedSession()
    
    let newURL = self.baseUrl + self.replyUrl
    let body1 = "packageName=com.appbyme.app118563&accessToken=\(self.accessToken)&apphash=\(str)&forumType=7&imei=862095023172437&platType=5&accessSecret=\(self.accessSecret)&sdkType=&sdkVersion=2.4.0&appName=%E6%B8%85%E6%B0%B4%E6%B2%B3%E7%95%94&json=\(hh.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)&forumKey=CBQJazn9Wws8Ivhr6U&imsi=460008158076181&act=reply"
    let request = NSMutableURLRequest(URL: NSURL(string: newURL)!)
    request.HTTPMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.HTTPBody = body1.dataUsingEncoding(NSUTF8StringEncoding)
    let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
      print(string)
      print("a")
    })
    task.resume()
  }
  // 网络公共函数
  func httpPost(url:String, var params:[String:AnyObject], withLogin:Bool,onSuccess:(JSON) -> Void, onFail:(String) -> Void) {
    if withLogin {
      // 判断是否登录
      if !User.getUser().load() {
        print("尚未登陆，没有权限")
        return
      }
      params["accessToken"] = self.accessToken
      params["accessSecret"] = self.accessSecret
    }
    let p = ParameterEncoding.URL
    Alamofire.request(.POST, url, parameters: params, encoding: p, headers: nil).responseJSON { (res) -> Void in
      guard res.result.error == nil else {
        onFail(url+"\(res.result.error)")
        return
      }
      
      let data = NSString.init(data: res.data!, encoding: NSUTF8StringEncoding)
      let json = JSON.parse(data as! String)
      onSuccess(json)
    }
  }
  
}
