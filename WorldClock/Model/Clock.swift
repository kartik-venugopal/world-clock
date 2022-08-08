//
//  Clock.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 15/03/22.
//

import Foundation

class Clock: Codable {
    
    var zone: WCTimeZone
    var name: String
    
    private static var format: TimeFormat {
        WorldClocks.shared.format
    }
    
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
        
        formatter.timeZone = zone.timeZone
        formatter.dateFormat = Self.format.formatString
        
        return "\(name): \(formatter.string(from: date))"
    }
}
