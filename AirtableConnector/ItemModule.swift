//
//  ItemModule.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/1/27.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

protocol DBItemBase {
    var doubanUrl: String { get }
    var unique: String? { get }

    func fillFromDoubanApi(doubanID: String, inContext context: NSManagedObjectContext?)
    func updateItem(inContext context: NSManagedObjectContext?, updateDidFinish closure: (()->Void)?)
    
    func getMyRating() -> Float
    func rate(withRating myRating: Float)
    
    func getDate() -> NSDate
    func setDate(date: NSDate?)
    
    var mobileUrl: String { get }
}
