//
//  DBBookItem+CoreDataClass.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/3/7.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreData

public class DBBookItem: NSManagedObject, DBItemBase {
    
    var unique: String? {
        return self.id
    }
    
    var doubanUrl: String {
        get {
            return "https://api.douban.com/v2/book/"
        }
    }
    
    var mobileUrl: String {
        get {
            return "https://m.douban.com/book/subject/" + self.unique!
        }
    }
    
    public class func InsertBookItem(id: String, inContext context: NSManagedObjectContext?) {
        guard context != nil else {
            return
        }
        
        let request: NSFetchRequest<DBBookItem> = DBBookItem.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            if try context?.count(for: request) != 0 {
                return
            } else {
                if let item = NSEntityDescription.insertNewObject(forEntityName: "DBBookItem", into: context!) as? DBBookItem {
                    item.rate(withRating: 0.0)
                    item.fillFromDoubanApi(doubanID: id, inContext: context)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return
    }
    
    func fillFromDoubanApi(doubanID: String, inContext context: NSManagedObjectContext?) {
    
        Alamofire.request(self.doubanUrl+doubanID)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let date = NSDate()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM"
                    self.yearMonth = formatter.string(from: date as Date)
                    self.id = doubanID
                    self.dateAdded = date
                    self.author = json["author"].arrayValue.map({$0.stringValue}).joined(separator: ", ")
                    self.title = json["title"].string
                    self.firstLetter = json["title"].string?.transformToPinYin()[0].capitalized
                    self.rating = json["rating"]["average"].floatValue
                    self.originalTitle = json["origin_title"].string
                    self.summary = json["summary"].string
                    self.images = DBImageSet.imageSet(fromJSON: json["images"], inContext: context)
                    
                    // save
                    do {
                        try context?.save()
                        print("database saved!")
                    } catch let error {
                        print(error.localizedDescription)
                    }
                case .failure( _):
                    print("Failed to connect to douban API")
                }
        }
    }
    
    func updateItem(inContext context: NSManagedObjectContext?, updateDidFinish closure: (()->Void)?) {
        
        Alamofire.request(self.doubanUrl+self.id!)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.rating = json["rating"]["average"].floatValue
                    self.images = DBImageSet.imageSet(fromJSON: json["images"], inContext: context)
                    // save
                    do {
                        try context?.save()
                        if closure != nil {
                            closure!()
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                case .failure( _):
                    print("Failed to connect to douban API")
                }
        }
    }
    
    func getMyRating() -> Float {
        return self.myRating
    }
    
    func rate(withRating myRating: Float) {
        self.myRating = myRating
    }
    
    func getDate() -> NSDate {
        return self.dateAdded!
    }
    
    func setDate(date: NSDate?) {
        if let newdate = date {
            self.dateAdded = newdate
        }
    }

}
