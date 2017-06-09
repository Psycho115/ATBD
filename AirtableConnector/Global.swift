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
    
    static let count = 3

    case noSection
    case byMonth
    case byTitleFirstLetter
    
    func typeStr() -> String {
        switch self {
        case .noSection:
            return "不分组"
        case .byMonth:
            return "按添加时间"
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
        case .byTitleFirstLetter:
            return 1
        }
    }
    
    static func names() -> [String] {
        return ["不分组", "按首字母", "按添加时间"]
    }

}

enum SortType {
    static let count = 4
    
    case byTimeAdded
    case byRating
    case byMyRating
    case byTitle
    
    func typeStr() -> String {
        switch self {
        case .byTimeAdded:
            return "按添加时间"
        case .byRating:
            return "按豆瓣评分"
        case .byMyRating:
            return "按我的评分"
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
        case .byMyRating:
            return 2
        case .byTitle:
            return 3
        }
    }
    
    static func names() -> [String] {
        return ["按添加时间", "按豆瓣评分", "按我的评分", "按首字母"]
    }

}

struct SortSettings {
    var sectionType = SectionType.noSection
    var sortType = SortType.byTimeAdded
    var reversed = false
    
    mutating func matchSort(int: Int) {
        switch int {
        case 0:
            self.sortType = .byTimeAdded
        case 1:
            self.sortType = .byRating
        case 2:
            self.sortType = .byMyRating
        case 3:
            self.sortType = .byTitle
        default:
            break
        }
    }
    
    mutating func matchSection(int: Int) {
        switch int {
        case 0:
            self.sectionType = .noSection
        case 1:
            self.sectionType = .byTitleFirstLetter
        case 2:
            self.sectionType = .byMonth
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
    
    func entityName() -> String? {
        switch self {
        case .unsigned:
            return nil
        case .books:
            return "DBBookItem"
        case .movies:
            return "DBMovieItem"
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
    
    func nameTitle() -> String? {
        switch self {
        case .unsigned:
            return nil
        case .books:
            return "Books"
        case .movies:
            return "Movies"
        }
    }
}

var tableType = TableType.unsigned

