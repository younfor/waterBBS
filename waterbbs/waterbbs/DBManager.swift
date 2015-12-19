//
//  DBManager.swift
//  waterbbs
//
//  Created by y on 15/12/19.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit
import CoreData

class DBManager: NSObject {
  
  static var context:NSManagedObjectContext?

  class func DBContext() -> NSManagedObjectContext {
    if self.context != nil {
      return self.context!
    }
    self.context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
    let model = NSManagedObjectModel.mergedModelFromBundles(nil)
    let store = NSPersistentStoreCoordinator(managedObjectModel: model!)
    let doc = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last
    let sqlite = doc!+"/data.sqlite"
    print(sqlite)
    do {
      try store.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: NSURL.init(fileURLWithPath: sqlite), options: nil)
    } catch _{
      print("数据实例存储错误")
    }
    self.context?.persistentStoreCoordinator = store

    return self.context!
  }
  //----------------- 社区 ------------
  class func test() {
    
  }
  // 查询
  class func DBGroupList() -> [Group]? {
    let req = NSFetchRequest(entityName: "Group")
    do {
      let datas = try DBContext().executeFetchRequest(req)
      return datas as? [Group]
    } catch _ {
      print("数据库请求失败:社区")
    }
    return nil
  }
  // 写入
  class func DBAddGroupList(datas:[Forum]) {
    for forumfather in datas {
      let fathername = forumfather.board_category_name
      for forumchild in forumfather.board_list! {
        // 更新数据库
        let req = NSFetchRequest(entityName: "Group")
        let pre = NSPredicate.init(format: "board_name=%@", forumchild.board_name)
        req.predicate = pre
        do {
          let results = try DBContext().executeFetchRequest(req)
          var group:Group?
          if results.count > 0 {
            group = results.first as? Group
          } else {
            group = NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: DBContext()) as? Group
            group?.is_collected = NSNumber.init(bool: false)
          }
          group?.board_father_name = fathername
          group?.board_id = forumchild.board_id
          group?.board_name = forumchild.board_name
          group?.td_posts_num = forumchild.td_posts_num
          if forumchild.isCollected != nil {
            group?.is_collected = forumchild.isCollected
          }
          try DBContext().save()
        } catch _ {
          print("写入失败")
        }
        
      }
    }
  }
}
