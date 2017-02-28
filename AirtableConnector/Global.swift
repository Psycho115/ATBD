//
//  Global.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/3.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import Foundation
import UIKit

//sort setting

enum SectionType {
    case noSection
    case byYear
    case byMonth
    case byTitleFirstLetter
    
    func typeStr() -> String {
        switch self {
        case .noSection:
            return "不分组"
        case .byMonth:
            return "按月份"
        case .byYear:
            return "按年份"
        case .byTitleFirstLetter:
            return "按首字母"
        }
    }
    
    func convertToInt() -> Int {
        switch self {
        case .noSection:
            return 0
        case .byMonth:
            return 2
        case .byYear:
            return 3
        case .byTitleFirstLetter:
            return 1
        }
    }
}

enum SortType {
    case byTimeAdded
    case byRating
    case byTitle
    
    func typeStr() -> String {
        switch self {
        case .byTimeAdded:
            return "按添加时间"
        case .byRating:
            return "按评分"
        case .byTitle:
            return "按首字母"
        }
    }
    
    func convertToInt() -> Int {
        switch self {
        case .byTimeAdded:
            return 0
        case .byRating:
            return 1
        case .byTitle:
            return 2
        }
    }

}

struct SortSettings {
    var sectionType = SectionType.noSection
    var sortType = SortType.byTimeAdded
    var reversed = false
    
    mutating func matchSort(str: String) {
        switch str {
        case "按添加时间":
            self.sortType = .byTimeAdded
        case "按评分":
            self.sortType = .byRating
        case "按首字母":
            self.sortType = .byTitle
        default:
            break
        }
    }
    
    mutating func matchSection(str: String) {
        switch str {
        case "不分组":
            self.sectionType = .noSection
        case "按首字母":
            self.sectionType = .byTitleFirstLetter
        case "按月份":
            self.sectionType = .byMonth
        case "按年份":
            self.sectionType = .byYear
        default:
            break
        }
    }
    
    func convertToInt() -> (Int, Int) {
        return (self.sectionType.convertToInt(), self.sortType.convertToInt())
    }
    
    static func ==(left: SortSettings, right: SortSettings) -> Bool {
        return (left.sortType == right.sortType) && (left.sectionType == right.sectionType) && (left.reversed == right.reversed)
    }
}

var sortSetting = SortSettings()

//table type

enum TableType {
    case unsigned
    case books
    case movies
    
    func mainUrl() -> String? {
        switch self {
        case .unsigned:
            return nil
        case .books:
            return "https://api.airtable.com/v0/app5uCGy9XkFmDsi3/Finished"
        case .movies:
            return "https://api.airtable.com/v0/appsuciTXw4XCTgZ8/Finished"
        }
    }
    
    func doubanUrl() -> String? {
        switch self {
        case .unsigned:
            return nil
        case .books:
            return "https://api.douban.com/v2/book/"
        case .movies:
            return "https://api.douban.com/v2/movie/subject/"
        }
    }
    
    func doubanSearchUrl() -> String? {
        switch self {
        case .unsigned:
            return nil
        case .books:
            return "https://api.douban.com/v2/book/search"
        case .movies:
            return "https://api.douban.com/v2/movie/search"
        }
    }
    
    func tintColor() -> UIColor? {
        switch self {
        case .unsigned:
            return nil
        case .books:
            return UIColor.lightBlue
        case .movies:
            return UIColor.lightRed
        }
    }
}

var tableType = TableType.unsigned

