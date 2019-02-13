//
//  NSDate+TimeAgo.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 09/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation

extension NSDate {

    static public func timeAgoSince(_ date: NSDate?, shortPattern: Bool = false) -> String? {
        guard let date = date as Date? else { return nil }
        return timeAgoSince(date, shortPattern: shortPattern)
    }

    static public func timeAgoSince(_ date: Date?, shortPattern: Bool = false) -> String? {

        guard let date = date else { return nil }
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])

        if let year = components.year {
            return timeAgoText(shortPattern, amount: year, shortText: "y", plural: "years", singular: "year")
        }

        if let month = components.month {
            return timeAgoText(shortPattern, amount: month, shortText: "m", plural: "months", singular: "month")
        }

        if let week = components.weekOfYear {
            return timeAgoText(shortPattern, amount: week, shortText: "w", plural: "weeks", singular: "week")
        }

        if let day = components.day {
            return timeAgoText(shortPattern, amount: day, shortText: "d", plural: "days", singular: "day")
        }

        if let hour = components.hour {
            return timeAgoText(shortPattern, amount: hour, shortText: "h", plural: "hours", singular: "hour")
        }

        if let minute = components.minute {
            return timeAgoText(shortPattern, amount: minute, shortText: "min", plural: "minutes", singular: "minute")
        }

        if let second = components.second {
            return timeAgoText(shortPattern, amount: second, shortText: "s", plural: "seconds", singular: "second")
        }

        return "Just now"
    }

    fileprivate static func timeAgoText(_ shortPattern: Bool,
                                        amount: Int,
                                        shortText: String,
                                        plural: String,
                                        singular: String) -> String {
        if shortPattern {
            return "\(amount) \(shortText)"
        } else if amount >= 2 {
            return "\(amount) \(plural) ago"
        }
        return "Last \(singular)"
    }
}
