//
//  Date+Ext.swift
//  MyHealthShare
//
//  Created by 寺田 克彦 on 2018/11/30.
//  Copyright © 2018 beowulf-tech. All rights reserved.
//

import Foundation

extension Date
{
    public init(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil)
    {
        let interval: TimeInterval = Date().fixed(
            year:   year,
            month:  month,
            day:    day,
            hour:   hour,
            minute: minute,
            second: second
            ).timeIntervalSince1970
        
        self.init( timeIntervalSince1970: interval )
    }
    
    public func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date
    {
        let calendar = self.calendar
        
        var comp = DateComponents()
        comp.year   = year   ?? calendar.component(.year,   from: self)
        comp.month  = month  ?? calendar.component(.month,  from: self)
        comp.day    = day    ?? calendar.component(.day,    from: self)
        comp.hour   = hour   ?? calendar.component(.hour,   from: self)
        comp.minute = minute ?? calendar.component(.minute, from: self)
        comp.second = second ?? calendar.component(.second, from: self)
        
        return calendar.date(from: comp)!
    }
    
    public var calendar: Calendar
    {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        calendar.locale   = .current
        return calendar
    }
    
    public var year: Int
    {
        return calendar.component(.year, from: self)
    }
    
    public var month: Int
    {
        return calendar.component(.month, from: self)
    }
    
    public var day: Int
    {
        return calendar.component(.day, from: self)
    }
    
    public var hour: Int
    {
        return calendar.component(.hour, from: self)
    }
    
    public var minute: Int
    {
        return calendar.component(.minute, from: self)
    }
    
    public var second: Int
    {
        return calendar.component(.second, from: self)
    }
}
