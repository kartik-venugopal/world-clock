//
//  ClockEditContext.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 29/03/22.
//

import Foundation

class ClockEditContext {

    var clock: Clock?
    
    var isClockBeingEdited: Bool {clock != nil}
    
    static let shared: ClockEditContext = .init()
    
    private init() {}
    
    func clear() {
        clock = nil
    }
}
