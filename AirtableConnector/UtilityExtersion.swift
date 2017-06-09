//
//  UtilityExtersion.swift
//  AirtableConnector
//
//  Created by 唐敬哲 on 2017/2/6.
//  Copyright © 2017年 唐敬哲. All rights reserved.
//

import Foundation

extension Array {
    
    var decompose:(head:Element,tail:[Element])?{
        return count > 0 ? (self[0],Array(self[1 ..< count])) : nil
    }
    
}

func quicksort<T: Comparable>(arr: inout [T], left: Int, right: Int) {
    if left < right {
        let p = partion(arr: &arr, left: left, right: right)
        quicksort(arr: &arr, left: left, right: p - 1)
        quicksort(arr: &arr, left: p + 1, right: right)
    }
}

func swap<T>(arr: inout [T], a: Int, b: Int) {
    let temp = arr[a]
    arr[a] = arr[b]
    arr[b] = temp
}

func partion<T: Comparable>(arr: inout [T], left: Int, right: Int) -> Int {
    let pivotValue = arr[right]
    var storeIndex = left
    for i in left..<right {
        if arr[i] < pivotValue {
            swap(arr: &arr, a: i, b: storeIndex)
            storeIndex += 1
        }
    }
    swap(arr: &arr, a: storeIndex, b: right)
    return storeIndex
}

extension String {
    
    subscript(pos: Int) -> String {
        precondition(pos >= 0, "character position can't be negative")
        guard pos < characters.count else { return "" }
        let idx = index(startIndex, offsetBy: pos)
        return self[idx...idx]
    }
    
    func transformToPinYin() -> String {
        
        let mutableString = NSMutableString(string: self)
        //把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        
        let string = String(mutableString)
        //去掉空格
        return string.replacingOccurrences(of: " ", with: "")
    }

}

extension NSDate {
    
    var formatForDate: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter.string(from: self as Date)
        }
    }
    
}
