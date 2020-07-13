//
//  DateExtension.swift
//  AsteroidVPN-iOS
//
//  Created by Maynard on 2018/1/18.
//  Copyright © 2018年 Maynard. All rights reserved.
//

import Foundation

extension Date {
    func isSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func isSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    
    var formatterString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            //            let locale = Locale.current
            
            let dateStr = dateFormatter.string(from: self)
            return dateStr
            
        }
    }
    
    var videoTimeFormatterString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .short
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            //            let locale = Locale.current
            
            let dateStr = dateFormatter.string(from: self)
            return dateStr
            
        }
    }
}

extension Int {
    func timeHourString() -> String {
        let seconds = self
        let hour = String(format: "%02ld", seconds/3600)
        let minute = String(format: "%02ld", (seconds%3600)/60)
        let second = String(format: "%02ld", seconds%60)
        let timeString = String(format: "%@:%@:%@", hour, minute, second)
        return timeString
    }
}
