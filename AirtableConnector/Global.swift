//
//  Global.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/3.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import Foundation

//sort setting

enum SectionType {
    case noSection
    case byYear
    case byMonth
    case byTitleFirstLetter
    
    func typeStr() -> String {
        switch self {
        case .noSection:
            return "未分组"
        case .byMonth:
            return "按加入月份"
        case .byYear:
            return "按加入年份"
        case .byTitleFirstLetter:
            return "按首字母"
        }
    }
}

enum SortType {
    case byTimeAdded
    case byRating
    case byTitle
    
    func match(str: String) -> SortType? {
        if (str == SortType.byRating.typeStr()) { return SortType.byRating }
        else if (str == SortType.byTitle.typeStr()) { return SortType.byTitle }
        else if (str == SortType.byTimeAdded.typeStr()) { return SortType.byTimeAdded }
        else { return nil }
    }
    
    func typeStr() -> String {
        switch self {
        case .byTimeAdded:
            return "按加入时间"
        case .byRating:
            return "按评分"
        case .byTitle:
            return "按标题"
        }
    }

}

struct SortSettings {
    var sectionType = SectionType.noSection {
        didSet {
            print("\(self.sectionType) is selected!")
        }
    }
    var sortType = SortType.byTimeAdded {
        didSet {
            print("\(self.sortType) is selected!")
        }
    }
    var reversed = false
    
    mutating func matchSort(str: String) {
        if (str == SortType.byRating.typeStr()) { self.sortType = .byRating }
        else if (str == SortType.byTitle.typeStr()) { self.sortType = .byTitle }
        else if (str == SortType.byTimeAdded.typeStr()) { self.sortType = .byTimeAdded }
        else {print("no match")}
    }
    
    mutating func matchSection(str: String) {
        if (str == SectionType.byMonth.typeStr()) { self.sectionType = .byMonth }
        else if (str == SectionType.byTitleFirstLetter.typeStr()) { self.sectionType = .byTitleFirstLetter }
        else if (str == SectionType.byYear.typeStr()) { self.sectionType = .byYear }
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
}

var tableType = TableType.unsigned

