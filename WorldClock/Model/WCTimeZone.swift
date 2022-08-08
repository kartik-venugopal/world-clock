//
//  WCTimeZone.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 16/03/22.
//

import Foundation

struct WCTimeZone: Codable, CustomStringConvertible {
    
    let timeZone: TimeZone
    
    let offsetHours: Int
    let offsetMins: Int
    let signedOffsetAsSeconds: Int
    let isOffsetNegative: Bool
    
    let isDST: Bool
    
    let index: Int
//        didSet {
//            print("Index for '\(location)' is now: \(index)")
//        }
//    }
    
    let location: String
    
    static var allTimeZones: [WCTimeZone] = {
        
        var index: Int = 0
        
        let zones: [TimeZone] = TimeZone.knownTimeZoneIdentifiers.compactMap {TimeZone(identifier: $0)}
            .sorted(by: {z1, z2 in
                
                // Sort by:
                // 1 - Signed offset (in seconds) from GMT
                // 2 - Location string, if offsets match
                
                let offset1 = z1.secondsFromGMT()
                let offset2 = z2.secondsFromGMT()
                
                if offset1 == offset2 {
                    return z1.identifier < z2.identifier
                } else {
                    return offset1 < offset2
                }
            })
        
        let wcZones: [WCTimeZone] = zones.enumerated().map {index, zone in
            WCTimeZone(index: index, timeZone: zone)
        }
        
//        for (index, var zone) in zones.enumerated() {
//            zone.index = index
//            print("\nZone \(zone.index): '\(zone.location)'")
//        }
        
        return wcZones
    }()
    
    init(index: Int, timeZone: TimeZone) {
        
        self.index = index
        self.timeZone = timeZone
        
        let signedOffset = timeZone.secondsFromGMT()
        self.signedOffsetAsSeconds = signedOffset
        self.isOffsetNegative = signedOffset < 0
        
        var offsetSeconds = abs(timeZone.secondsFromGMT())
        
        self.offsetHours = offsetSeconds / 3600
        offsetSeconds -= offsetHours * 3600
        
        self.offsetMins = offsetSeconds / 60
        offsetSeconds -= offsetMins * 60
        
        self.isDST = timeZone.isDaylightSavingTime()
        self.location = timeZone.identifier
    }
    
//    internal init(index: Int, location: String, offsetHours: Int, offsetMins: Int, isDST: Bool) {
//
//        self.index = index
//        self.location = location
//
//        self.offsetHours = offsetHours
//        self.offsetMins = offsetMins
//
//        let isNegative = offsetHours < 0
//        let offset = abs(offsetHours) * 3600 + offsetMins * 60
//        offsetAsSeconds = offset * (isNegative ? -1 : 1)
//
//        self.timeZone = TimeZone.init(secondsFromGMT: offsetAsSeconds)!
//        self.isDST = isDST
//    }
    
    var humanReadableLocation: String {
        
        let split = location.split(separator: "/")
        return (split.count >= 2 ? String(split.last!) : location).replacingOccurrences(of: "_", with: " ")
    }
    
    var nextDSTTransition: Date? {
        timeZone.nextDaylightSavingTimeTransition
    }
    
    var description: String {
        "\(location) - \(humanReadableOffset)\(isDST ? " (DST)" : "")"
    }
    
    var humanReadableOffset: String {
        "GMT\(isOffsetNegative ? "-" : "+")\(offsetHours):\(String(format: "%02d", offsetMins))"
    }
}

extension SignedInteger {
    
    mutating func getAndIncrement() -> Self {
        
        let selfBeforeIncrement: Self = self
        self += 1
        return selfBeforeIncrement
    }
}
