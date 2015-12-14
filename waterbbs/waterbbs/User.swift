//
//  User.swift
//  waterbbs
//
//  Created by y on 15/12/14.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class User: NSObject {
    var accessToken:String?
    var accessSecret:String?
    var apphash:String!
    var sdkVersion:String!
    var forumKey:String!
    var platType:String!
    var username:String?
    var password:String?
    var avatar:String?
    var userName:String?
    var uid:String!
    // location
    var longitude:String?
    var latitude:String?
    var location:String?
    // 单例
    static let user = User()
    class func getUser() -> User {
        return user
    }
    // 存储
    func save() -> Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(self.accessToken, forKey: "accessToken")
        defaults.setObject(self.accessSecret, forKey: "accessSecret")
        defaults.setObject(self.userName, forKey: "userName")
        defaults.setObject(self.avatar, forKey: "avatar")
        if self.accessToken == nil {
            return false
        } else {
            return true
        }
    }
    // 退出登录
    func clear() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "accessToken")
        
    }
    // 提取
    func load() -> Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        self.accessToken = defaults.objectForKey("accessToken") as? String
        self.accessSecret = defaults.objectForKey("accessSecret") as? String
        self.userName = defaults.objectForKey("userName") as? String
        self.avatar = defaults.objectForKey("avatar") as? String
        if self.accessToken == nil {
            return false
        } else {
            return true
        }
    }
}
