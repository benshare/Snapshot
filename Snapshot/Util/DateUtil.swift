//
//  DateUtil.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/24/21.
//

import Foundation

class DateFormats {
    // dateFormats: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    private let formatter = DateFormatter()
    
    func monthDayYear(date: Date) -> String {
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: date)
    }
    
    func monthDayYearTime(date: Date) -> String {
        formatter.dateFormat = "MM/dd/yy' at 'HH:mm"
        return formatter.string(from: date)
    }
}

let DATE_FORMATS = DateFormats()
