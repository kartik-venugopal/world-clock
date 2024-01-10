//
//  Clock.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 15/03/22.
//

import Foundation

class Clock: Codable {
    
    var name: String
    var zone: WCTimeZone
    
    private static var formatString: String {
        worldClocks.format.formatString
    }
    
    lazy var formatter: DateFormatter = {
       
        let formatter = DateFormatter()
        formatter.timeZone = zone.timeZone
        formatter.dateFormat = Self.formatString
        
        return formatter
    }()
    
    init(zone: WCTimeZone, name: String) {
        
        self.zone = zone
        self.name = name
    }
    
    func time(for date: Date) -> String {
        
        formatter.timeZone = zone.timeZone
        formatter.dateFormat = Self.formatString
        
        let showDST = worldClocks.indicateDST && zone.isDST(for: date)
        return "\(name)\(showDST ? " (DST)" : ""): \(formatter.string(from: date))"
    }
}
