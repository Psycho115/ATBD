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
    
    public var deleted: Bool = false
    public var updated: Bool = false
    public var title: String = ""
    public var rating: Double = 0.0
    public var doubanID: String = ""
    public var airtableID: String = ""
    public var image: String = ""
    
    public var dateAdded: Date?
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
    
    public func getDateComponent(unit: Calendar.Component) -> Int {
        return Calendar.current.component(unit, from: self.dateAdded!)
    }
    
    init(updated: Bool, doubanID: String, airtableID: String, dateAdded: String) {
        self.updated = updated
        self.doubanID = doubanID
        self.airtableID = airtableID
        self.strDateAdded = dateAdded
    }
    
    convenience init() {
        self.init(updated: false, doubanID: "", airtableID: "", dateAdded: "")
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
    
    public var author = ""
    public var isbn = 0
    
    static var itemDetailTitle = ["图片", "标题", "作者", "评分", "添加日期"]
    
    init(fromDoubanJSON json: JSON, doubanID: String, airtableID: String, dateAdded: String) {
        super.init(updated: false, doubanID: doubanID, airtableID: airtableID, dateAdded: dateAdded)
        let authorsArray =  json["author"].arrayValue.map({$0.stringValue})
        self.doubanID = doubanID
        self.author = authorsArray.joined(separator: ", ")
        self.title = json["title"].stringValue
        self.rating = Double(json["rating"]["average"].stringValue)!
        self.image = json["images"]["large"].stringValue
        self.isbn = Int(json["isbn13"].stringValue)!
    }
    
    init(fromAirtableJSON json: JSON) {
        let airtableID = json["id"].stringValue
        let strDateAdded = json["fields"]["Time Added"].stringValue
        let doubanID = json["fields"]["ID"].stringValue
        super.init(updated: true, doubanID: doubanID, airtableID: airtableID, dateAdded: strDateAdded)
        self.title = json["fields"]["Title"].stringValue
        self.author = json["fields"]["Author"].stringValue
        self.rating = json["fields"]["Rating"].doubleValue
        self.image = json["fields"]["Cover"][0]["url"].stringValue
        self.isbn = json["fields"]["ISBN"].intValue
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
    
    public var directors = ""
    public var actors = ""
    
    static var itemDetailTitle = ["图片", "标题", "导演", "演员", "评分", "添加日期"]
    
    init(fromDoubanJSON json: JSON, doubanID: String, airtableID: String, dateAdded: String) {
        super.init(updated: false, doubanID: doubanID, airtableID: airtableID, dateAdded: dateAdded)
        let directorsArray =  json["directors"].arrayValue.map({$0["name"].stringValue})
        self.directors = directorsArray.joined(separator: ", ")
        let actorsArray =  json["casts"].arrayValue.map({$0["name"].stringValue})
        self.actors = actorsArray.joined(separator: ", ")
        self.title = json["title"].stringValue
        self.rating = Double(json["rating"]["average"].stringValue)!
        self.image = json["images"]["large"].stringValue
    }
    
    init(fromAirtableJSON json: JSON) {
        let airtableID = json["id"].stringValue
        let strDateAdded = json["fields"]["Time Added"].stringValue
        let doubanID = json["fields"]["ID"].stringValue
        super.init(updated: true, doubanID: doubanID, airtableID: airtableID, dateAdded: strDateAdded)
        self.doubanID = json["fields"]["ID"].stringValue
        self.title = json["fields"]["Title"].stringValue
        self.directors = json["fields"]["Directors"].stringValue
        self.rating = json["fields"]["Rating"].doubleValue
        self.image = json["fields"]["Poster"][0]["url"].stringValue
        self.actors = json["fields"]["Actors"].stringValue
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
