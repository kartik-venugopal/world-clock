//
//  WCTimeZone.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 16/03/22.
//

import Foundation

struct WCTimeZone: Codable, CustomStringConvertible {
    
    let timeZone: TimeZone
    
    let index: Int
    
    let location: String
    let humanReadableLocation: String
    let region: String
    let city: String
    
    let offsetSeconds: Int
    
    private let offsetHours: Int
    private let offsetMins: Int
    private let isOffsetNegative: Bool
    
    let description: String
    let humanReadableOffset: String
    
    func isDST(for date: Date) -> Bool {
        timeZone.isDaylightSavingTime(for: date)
    }
    
    var nextDSTTransition: Date? {
        timeZone.nextDaylightSavingTimeTransition
    }
    
    var nextDSTTransitionString: String? {
        
        if let transition = self.nextDSTTransition {
            return Self.formattedDateString(forZone: self, date: transition)
        }
        
        return nil
    }
    
    init(index: Int, timeZone: TimeZone) {
        
        self.index = index
        self.timeZone = timeZone
        
        let signedOffset = timeZone.secondsFromGMT()
        self.offsetSeconds = signedOffset
        
        self.isOffsetNegative = signedOffset < 0
        
        var offsetSeconds = abs(signedOffset)
        
        self.offsetHours = offsetSeconds / 3600
        offsetSeconds -= offsetHours * 3600
        
        self.offsetMins = offsetSeconds / 60
        offsetSeconds -= offsetMins * 60
        
        self.location = timeZone.identifier
        let humanReadableLocation = self.location.replacingOccurrences(of: "_", with: " ")
        
        self.humanReadableOffset = "GMT\(isOffsetNegative ? "-" : "+")\(offsetHours):\(String(format: "%02d", offsetMins))"
        
        let split = humanReadableLocation.split(separator: "/")
        
        if split.count >= 2 {
            
            self.region = String(split[0..<(split.count - 1)].joined(separator: " > "))
            self.city = String(split.last!)
            
        } else {
            
            self.region = location
            self.city = location
        }
        
        self.humanReadableLocation = humanReadableLocation.replacingOccurrences(of: "/", with: " > ")
        
        self.description = "\(region) > \(city)    |    \(humanReadableOffset)"
    }
}

// ----------------------------------------------------------------------------------

// MARK: Static members

extension WCTimeZone {
    
    static var allTimeZones: [WCTimeZone] = {
        
        let zones: [TimeZone] = TimeZone.knownTimeZoneIdentifiers.compactMap {TimeZone(identifier: $0)}
            .sorted(by: {z1, z2 in
                
                // Sort by:
                // 1 - Offset (in seconds) from GMT
                // 2 - Location string, if offsets match
                
                let offset1 = z1.secondsFromGMT()
                let offset2 = z2.secondsFromGMT()
                
                if offset1 == offset2 {
                    return z1.identifier < z2.identifier
                } else {
                    return offset1 < offset2
                }
            })
        
        return zones.enumerated().map {index, zone in
            WCTimeZone(index: index, timeZone: zone)
        }
    }()
    
    static let formatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, YYYY"
        return formatter
    }()
    
    static func formattedDateString(forZone zone: WCTimeZone, date: Date) -> String {
        
        formatter.timeZone = zone.timeZone
        return formatter.string(from: date)
    }
}

//extension Date {
//
//    func addingHours(_ numHours: Int) -> Date {
//        Calendar.current.date(byAdding: .hour, value: numHours, to: self)!
//    }
//
//    func addingSeconds(_ numSecs: Int) -> Date {
//        Calendar.current.date(byAdding: .second, value: numSecs, to: self)!
//    }
//}
//
//extension TimeZone {
//
//    func willClocksMoveBackAtDSTTransition(_ date: Date) -> Bool {
//
//        let hoursBeforeDate: Date = date.addingHours(-5)
//        let hoursAfterDate: Date = date.addingHours(5)
//
//        let offsetBeforeDate: TimeInterval = daylightSavingTimeOffset(for: hoursBeforeDate)
//        let offsetAfterDate: TimeInterval = daylightSavingTimeOffset(for: hoursAfterDate)
//
//        return offsetAfterDate < offsetBeforeDate
//    }
//}
