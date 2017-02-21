//
//  ItemModule.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/1/27.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import Foundation
import SwiftyJSON

class ItemBase: Comparable {
    
    public var updated: Bool = false
    public var title: String = ""
    public var rating = 0.0
    public var airtableID: String = ""
    public var image: String = ""
    public var strDateAdded: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: self.dateAdded!)
        }
        set {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.dateAdded = formatter.date(from: newValue)
        }
    }
    
    public var dateAdded: Date?
    
    public func getDateComponent(unit: Calendar.Component) -> Int {
        return Calendar.current.component(unit, from: self.dateAdded!)
    }
    
    
    public var itemDetailTitle = [String]()
    
    func getItemJson() -> [String : [String : Any]]? {return nil}
    
    func getItemDetailArray() -> [String]? {return nil}
    
    static func <(left: ItemBase, right: ItemBase) -> Bool {
        switch sortSetting.sortType {
        case .byRating:
            return left.rating > right.rating
        case .byTimeAdded:
            return left.dateAdded! > right.dateAdded!
        case .byTitle:
            return left.title.transformToPinYin() < right.title.transformToPinYin()
        }
    }
    
    static func ==(left: ItemBase, right: ItemBase) -> Bool {
        switch sortSetting.sortType {
        case .byRating:
            return left.rating == right.rating
        case .byTimeAdded:
            return left.dateAdded! == right.dateAdded!
        case .byTitle:
            return left.title.transformToPinYin() == right.title.transformToPinYin()
        }
    }
    
}

class BookItem: ItemBase{
    
    public var doubanID = ""
    public var author = ""
    public var isbn = 0

    init(updated: Bool, doubanID: String, title: String, author: String, rating: Double, cover: String, isbn: Int, airtableID: String, dateAdded: String){
        super.init()
        self.updated = updated
        self.doubanID = doubanID
        self.title = title
        self.author = author
        self.rating = rating
        self.image = cover
        self.isbn = isbn
        self.airtableID = airtableID
        self.strDateAdded = dateAdded
        
        itemDetailTitle = ["图片", "标题", "作者", "评分", "添加日期"]
    }
    
    override func getItemDetailArray() -> [String]? {
        if self.doubanID != "" {
            return [self.image, self.title, self.author, String(self.rating), self.strDateAdded]
        } else {
            return nil
        }
    }
    
    override public func getItemJson() -> [String : [String : Any]]? {
        return [
            "fields" : [
                    "Title" : self.title,
                    "Author" : self.author,
                    "Rating" : self.rating,
                    "Cover" : [["url" : self.image]],
                    "ISBN" : self.isbn
            ]
        ]
    }

}


class MovieItem: ItemBase{
    
    public var doubanID = ""
    public var directors = ""
    public var actors = ""
    
    init(updated: Bool, doubanID: String, title: String, directors: String, rating: Double, poster: String, actors: String, airtableID: String, dateAdded: String){
        super.init()
        self.updated = updated
        self.doubanID = doubanID
        self.title = title
        self.directors = directors
        self.rating = rating
        self.image = poster
        self.actors = actors
        self.airtableID = airtableID
        self.strDateAdded = dateAdded

        itemDetailTitle = ["图片", "标题", "导演", "演员", "评分", "添加日期"]
    }
    
    override func getItemDetailArray() -> [String]? {
        if self.doubanID != "" {
            return [self.image, self.title, self.directors, self.actors, String(self.rating), self.strDateAdded]
        } else {
            return nil
        }
    }
    
    override public func getItemJson() -> [String : [String : Any]]? {
        return [
            "fields" : [
                "Title" : self.title,
                "Directors" : self.directors,
                "Rating" : self.rating,
                "Poster" : [["url" : self.image]],
                "Actors" : self.actors
            ]
        ]
    }
    
    
}
