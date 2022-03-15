//
//  Clock.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 15/03/22.
//

import Foundation

class Clock: Codable {
    
    var zone: WCTimeZone
    
    private static var format: TimeFormat {
        WorldClocks.shared.format
    }
    
    var name: String
    
    lazy var formatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.timeZone = zone.timeZone
        formatter.dateFormat = Self.format.formatString
        
        return formatter
    }()
    
    init(zone: WCTimeZone, name: String) {
        
        self.zone = zone
        self.name = name
    }
    
    func time(for date: Date) -> String {
        
        formatter.dateFormat = Self.format.formatString
        return "\(name): \(formatter.string(from: date))"
    }
}

enum TimeFormat: Int, Codable {
    
    case hoursMinutes_AM_PM
    case hoursMinutesSeconds_AM_PM
    case hoursMinutes_24hour
    case hoursMinutesSeconds_24hour
    
    var is24Hour: Bool {
        self == .hoursMinutes_24hour || self == .hoursMinutesSeconds_24hour
    }
    
    var showsSeconds: Bool {
        self == .hoursMinutesSeconds_AM_PM || self == .hoursMinutesSeconds_24hour
    }
    
    var formatString: String {
        
        switch self {
            
        case .hoursMinutes_AM_PM:
            return "h:mm a"
            
        case .hoursMinutesSeconds_AM_PM:
            return "h:mm:ss a"
            
        case .hoursMinutes_24hour:
            return "H:mm"
            
        case .hoursMinutesSeconds_24hour:
            return "H:mm:ss"
        }
    }
}
