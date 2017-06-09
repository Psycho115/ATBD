//
//  DBImageSet+CoreDataClass.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/3/7.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

public class DBImageSet: NSManagedObject {
    
    public class func imageSet(fromJSON json: JSON, inContext context: NSManagedObjectContext?) -> DBImageSet? {
        
        guard context != nil else {
            return nil
        }
        
        if let set = NSEntityDescription.insertNewObject(forEntityName: "DBImageSet", into: context!) as? DBImageSet {
            set.small = json["small"].string
            set.medium = json["medium"].string
            set.large = json["large"].string
            
            return set
        }
        
        return nil
    }
    
    
}

