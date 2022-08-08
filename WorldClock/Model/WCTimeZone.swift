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
    
    let offsetSeconds: Int
    
    private let offsetHours: Int
    private let offsetMins: Int
    private let isOffsetNegative: Bool
    
    let description: String
    let humanReadableOffset: String
    let humanReadableLocation: String
    
    let isDST: Bool
    
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
        
        self.isDST = timeZone.isDaylightSavingTime()
        self.location = timeZone.identifier
        
        self.humanReadableOffset = "GMT\(isOffsetNegative ? "-" : "+")\(offsetHours):\(String(format: "%02d", offsetMins))"
        self.description = "\(location) - \(humanReadableOffset)\(isDST ? " (DST)" : "")"
        
        let split = location.split(separator: "/")
        self.humanReadableLocation = (split.count >= 2 ? String(split.last!) : location).replacingOccurrences(of: "_", with: " ")
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
        formatter.dateFormat = "dd MMM, YYYY 'at' HH:mm"
        return formatter
    }()
    
    static func formattedDateString(forZone zone: WCTimeZone, date: Date) -> String {
        
        formatter.timeZone = zone.timeZone
        
//        print("\nDST Offset at date: \(date) is: \(zone.timeZone.daylightSavingTimeOffset(for: date.addingHours(5)))")
        
        // TODO: This will not work when beginning DST !!!
        let willClocksMoveBack: Bool = zone.timeZone.willClocksMoveBackAtDSTTransition(date)
        print("\nwillClocksMoveBack: \(willClocksMoveBack)")
        if willClocksMoveBack {
            return formatter.string(from: date.addingHours(1))
        } else {
            return formatter.string(from: date.addingHours(-1))
        }
    }
}

extension Date {
    
    func addingHours(_ numHours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: numHours, to: self)!
    }
    
    func addingSeconds(_ numSecs: Int) -> Date {
        Calendar.current.date(byAdding: .second, value: numSecs, to: self)!
    }
}

extension TimeZone {
    
    func willClocksMoveBackAtDSTTransition(_ date: Date) -> Bool {
        
        let hoursBeforeDate: Date = date.addingHours(-5)
        let hoursAfterDate: Date = date.addingHours(5)
        
        let offsetBeforeDate: TimeInterval = daylightSavingTimeOffset(for: hoursBeforeDate)
        let offsetAfterDate: TimeInterval = daylightSavingTimeOffset(for: hoursAfterDate)
        
        return offsetAfterDate < offsetBeforeDate
    }
}
