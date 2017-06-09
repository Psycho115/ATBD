//
//  DBMovieItem+CoreDataProperties.swift
//  
//
//  Created by 唐敬哲 on 2017/5/29.
//
//

import Foundation
import CoreData


extension DBMovieItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBMovieItem> {
        return NSFetchRequest<DBMovieItem>(entityName: "DBMovieItem")
    }

    @NSManaged public var cast: String?
    @NSManaged public var dateAdded: NSDate?
    @NSManaged public var director: String?
    @NSManaged public var firstLetter: String?
    @NSManaged public var id: String?
    public var noSectionName: String?  { return "所有电影" }
    @NSManaged public var originalTitle: String?
    @NSManaged public var rating: Float
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var yearMonth: String?
    @NSManaged public var myRating: Float
    @NSManaged public var images: DBImageSet?

}
