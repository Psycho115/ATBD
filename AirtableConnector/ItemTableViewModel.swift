//
//  ItemTableViewModel.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/24.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ItemTableViewModel {
    
    private var apiKey = "key8n8MkjeRV8cJCO"
    private var idDict = [String: (String, String, Bool)]()
    
    var performWhenItemsDidSet: (()->Void)? = nil
    var items = [ItemBase]() {
        didSet {
            if let closure = self.performWhenItemsDidSet { closure() }
        }
    }
    
    
    public var totalRecordsOnAirtable: Int = 0
    
    public var TotalItemsToBeUpdated: Int {
        get {
            let value = self.items.filter({ !($0.updated) && !($0.deleted) }).count
            self.itemsRemainsToBeUpdated = value
            return value
        }
    }
    var itemsRemainsToBeUpdated = 0
    
    public func clear() {
        self.totalRecordsOnAirtable = 0
        self.idDict.removeAll()
        self.items.removeAll()
    }
    
    public var fetchingProgress: Float {
        get {
            if self.totalRecordsOnAirtable == 0 {
                return 0.0
            } else {
                return Float(self.items.filter({ !($0.deleted) }).count) / Float(self.totalRecordsOnAirtable)
            }
        }
    }
    
    public func retrieveItems(completion: (()->Void)? = nil, failed: (()->Void)? = nil) {
        
        let authHeader: HTTPHeaders = ["Authorization": "Bearer \(apiKey)"]
        
        Alamofire.request(tableType.mainUrl()!, method: .get, headers: authHeader)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if self.idDict.count != 0 {
                        self.idDict.removeAll()
                    }
                    let swiftyJson = JSON(value)
                    self.totalRecordsOnAirtable = swiftyJson["records"].count
                    for (_,subJson):(String, JSON) in swiftyJson["records"] {
                        let doubanID = subJson["fields"]["ID"].stringValue
                        let completed: Bool
                        if let _ = subJson["fields"]["Title"].string {
                            completed = true
                            self.items.append(self.newItemFromAirtableJSON(swiftyJson: subJson))
                        } else { completed = false }
                        self.idDict[doubanID] = (subJson["id"].stringValue, subJson["fields"]["Time Added"].stringValue, completed)
                    }
                    self.getDoubanItems(completion:  completion, failed: failed)
                case .failure(let error):
                    print("Failed to connect to airtable API")
                    print(error)
                    if let closure = failed {
                        closure()
                    }
                }
        }
    }
    
    private func getDoubanItems(completion: (()->Void)? = nil, failed: (()->Void)? = nil){
        
        let base_url = tableType.doubanUrl()!
        
        for (douban_id, (airtableID, dateAdded, completed)) in self.idDict {
            if completed { continue }
            //retreive from douban
            Alamofire.request(base_url+douban_id)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let swiftyJson = JSON(value)
                        let douban_item = self.newItemFromDoubanJSON(doubanID: douban_id, airtableID: airtableID, dateAdded: dateAdded, swiftyJson: swiftyJson)
                        self.items.append(douban_item)
                        if let closure = completion { closure() }
                    case .failure( _):
                        print("Failed to connect to douban API")
                        if let closure = failed {
                            closure()
                        }
                    }
            }
        }
    }
    
    private func newItemFromDoubanJSON(doubanID: String, airtableID: String, dateAdded: String, swiftyJson: JSON) -> ItemBase {
        let item: ItemBase
        switch tableType {
        case .books:
            item = BookItem(fromDoubanJSON: swiftyJson, doubanID: doubanID, airtableID: airtableID, dateAdded: dateAdded)
        case.movies:
            item = MovieItem(fromDoubanJSON: swiftyJson, doubanID: doubanID, airtableID: airtableID, dateAdded: dateAdded)
        case .unsigned:
            item = ItemBase()
        }
        print("\(item.title) added from douban!")
        return item
    }
    
    private func newItemFromAirtableJSON(swiftyJson: JSON) -> ItemBase {
        let item: ItemBase
        switch tableType {
        case .books:
            item = BookItem(fromAirtableJSON: swiftyJson)
        case.movies:
            item = MovieItem(fromAirtableJSON: swiftyJson)
        case .unsigned:
            item = ItemBase()
        }
        print("\(item.title) added from airtable!")
        return item
    }
    
    public func updateItem(index: Int, completion: (()->Void)? = nil, failed: (()->Void)? = nil) {
        let item = items[index]
        let patch_data = item.getItemJson()
        let authHeader: HTTPHeaders = ["Authorization": "Bearer \(apiKey)"]
        if let patchUrl = tableType.mainUrl() {
            Alamofire.request(patchUrl+"/"+item.airtableID, method: .patch, parameters: patch_data, encoding: JSONEncoding.default, headers: authHeader).responseJSON { response in
                switch response.result {
                case .success( _):
                    item.updated = true
                    self.itemsRemainsToBeUpdated -= 1
                    print("\(item.title) updated")
                    if let closure = completion { closure() }
                case .failure( _):
                    print("Failed to connect to airtable API")
                    if let closure = failed { closure() }
                }
            }
        }
    }
    
    public func deleteItem(index: Int, completion: (()->Void)? = nil, failed: (()->Void)? = nil) {
        let item = items[index]
        item.deleted = true
        let authHeader: HTTPHeaders = ["Authorization": "Bearer \(apiKey)"]
        if let patchUrl = tableType.mainUrl() {
            Alamofire.request(patchUrl+"/"+item.airtableID, method: .delete, headers: authHeader)
                .responseJSON { response in
                switch response.result {
                case .success( _):
                    item.deleted = true
                    self.totalRecordsOnAirtable -= 1
                    if item.updated == false {
                        self.itemsRemainsToBeUpdated -= 1
                    }
                    print("\(item.title) deleted")
                    if let closure = completion { closure() }
                case .failure( _):
                    print("Failed to connect to airtable API")
                    if let closure = failed { closure() }
                }
            }
        }
    }

}
