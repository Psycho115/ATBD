//
//  DBImageSet+CoreDataProperties.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/3/7.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import Foundation
import CoreData


extension DBImageSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBImageSet> {
        return NSFetchRequest<DBImageSet>(entityName: "DBImageSet");
    }

    @NSManaged public var small: String?
    @NSManaged public var medium: String?
    @NSManaged public var large: String?
    @NSManaged public var movieItem: DBMovieItem?
    @NSManaged public var bookItem: DBBookItem?

}
