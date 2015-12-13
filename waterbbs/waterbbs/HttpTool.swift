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

// 主要处理网络后台接口数据调用
class HttpTool: NSObject {
    // 一些公共参数
    var accessToken:String! = "b72642d1ab2825cafcda5bd23027e"
    var accessSecret:String! = "7f55871fbbe423200ef1890910610"
    var avatar:String!
    let baseUrl = "http://bbs.uestc.edu.cn/mobcent/app/web/index.php?r="
    let loginUrl = "user/login&&type=login"
    let logoutUrl = "user/login&&type=logout"
    let atuserUrl = "forum/atuserlist"
    // 单例
    static let httpTool = HttpTool()
    class func getHttpTool() -> HttpTool {
        return httpTool
    }
    // 登陆
    func login(username:String,password:String,onSuccess:(() -> Void)?=nil, onFail:((String) -> Void)?=nil) {
        self.httpPost(self.baseUrl + self.loginUrl, params: ["username":username,"password":password], withLogin: false, onSuccess: { (data) -> () in
            
            print(data)
            onSuccess?()
            // 存储用户数据
            
            // default user
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
            
            // default user
            }) { (error) -> () in
                onFail?("请求失败:" + error)
        }
    }
    // 测试
    func test() {
        //self.login("cq361106306", password: "199288")
        self.atuserlist()
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
    // 判断是否登录
    func isLogined() -> Bool {
        //本地存储加载是否有
        //没有则报错并重新跳转登录界面
        //赋值给self.accessToken self.accessSecret
        return true;
    }
    // 网络公共函数
    func httpPost(url:String, var params:[String:AnyObject], withLogin:Bool, onSuccess:(JSON) -> Void, onFail:(String) -> Void) {
        if withLogin {
            // 判断是否登录
            if !isLogined() {
                print("非法获取数据")
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
