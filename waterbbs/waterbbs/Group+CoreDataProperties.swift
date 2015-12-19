//
//  Group+CoreDataProperties.swift
//  waterbbs
//
//  Created by y on 15/12/19.
//  Copyright © 2015年 younfor. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Group {

    @NSManaged var board_id: String?
    @NSManaged var board_name: String?
    @NSManaged var is_collected: NSNumber?
    @NSManaged var td_posts_num: String?
    @NSManaged var board_father_name: String?

}
