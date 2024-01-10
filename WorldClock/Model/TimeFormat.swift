//
//  TimeFormat.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 07/08/22.
//

import Foundation

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
