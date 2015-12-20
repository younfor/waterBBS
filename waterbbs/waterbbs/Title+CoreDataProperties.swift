//
//  Title+CoreDataProperties.swift
//  
//
//  Created by y on 15/12/20.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Title {

    @NSManaged var hits: String?
    @NSManaged var imageList: String?
    @NSManaged var last_reply_date: String?
    @NSManaged var pic_path: String?
    @NSManaged var replies: String?
    @NSManaged var subject: String?
    @NSManaged var title: String?
    @NSManaged var topic_id: String?
    @NSManaged var user_nick_name: String?
    @NSManaged var userAvatar: String?

}
