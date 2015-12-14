//
//  ForumChild.swift
//  waterbbs
//
//  Created by y on 15/12/14.
//  Copyright © 2015年 younfor. All rights reserved.
//

import UIKit

class ForumChild: NSObject {
    var board_child:String! //是否有子板块
    var board_content:String! //是否为空板块
    var board_id:String! //fid
    var board_img:String!
    var board_name:String! //板块名称
    var _description:String!
    var forumRedirect:String?
    var last_posts_date:String?
    var posts_total_num:Int!
    var td_posts_num:Int!
    var topic_total_num:Int!
}
