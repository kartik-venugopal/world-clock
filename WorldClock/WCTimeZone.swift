//
//  WCTimeZone.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 16/03/22.
//

import Foundation

struct WCTimeZone: Codable, CustomStringConvertible {
    
    internal init(location: String, offsetHours: Int, offsetMins: Int, isDST: Bool) {
        
        self.location = location
        self.offsetHours = offsetHours
        self.offsetMins = offsetMins
        self.isDST = isDST
    }
    
    let location: String
    
    var humanReadableLocation: String {
        
        let split = location.split(separator: "/")
        return (split.count >= 2 ? String(split.last!) : location).replacingOccurrences(of: "_", with: " ")
    }
    
    let offsetHours: Int
    let offsetMins: Int
    
    let isDST: Bool
    
    lazy var offsetAsSeconds: Int = {
        
        let isNegative = offsetHours < 0
        let offset = abs(offsetHours) * 3600 + offsetMins * 60
        
        return offset * (isNegative ? -1 : 1)
    }()
    
    lazy var timeZone: TimeZone = TimeZone.init(secondsFromGMT: offsetAsSeconds)!
    
    var description: String {
        "\(location) - \(humanReadableOffset)\(isDST ? " (DST)" : "")"
    }
    
    var humanReadableOffset: String {
        "GMT\(offsetHours >= 0 ? "+" : "")\(offsetHours):\(String(format: "%02d", offsetMins))"
    }
}
