//
//  WorldClocks.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 16/03/22.
//

import Foundation

class WorldClocks {
    
    static let shared: WorldClocks = .init()
    
    private(set) var clocks: [Clock] = []
    
    var format: TimeFormat = .hoursMinutes_AM_PM
    var indicateDST: Bool = true
    
    var numberOfClocks: Int {
        clocks.count
    }
    
    private static let defaultsKey_savedClocks: String = "worldClock.savedClocks"
    private static let defaultsKey_timeFormat: String = "worldClock.timeFormat"
    
    // ---------------------------------------------------------------------------------------------------------
    
    // MARK: init/de-init (UserDefaults persistence)
    
    func load() {
        
        self.clocks = defaults.decode([Clock].self, mappedToKey: Self.defaultsKey_savedClocks) ?? []
        self.format = defaults.decode(TimeFormat.self, mappedToKey: Self.defaultsKey_timeFormat) ?? .hoursMinutes_AM_PM
    }
    
    func save() {
        
        defaults.encode(clocks, mappedToKey: Self.defaultsKey_savedClocks)
        defaults.encode(format, mappedToKey: Self.defaultsKey_timeFormat)
    }
    
    // ---------------------------------------------------------------------------------------------------------
    
    // MARK: CRUD functions
    
    func addNewClock(_ newClock: Clock) {
        clocks.append(newClock)
    }
    
    func removeClocks(atIndices indices: [Int]) {
        
        for index in indices.sorted(by: >) {
            clocks.remove(at: index)
        }
    }
    
    func moveClockUp(at index: Int) {
        clocks.swapAt(index, index - 1)
    }
    
    func moveClockDown(at index: Int) {
        clocks.swapAt(index, index + 1)
    }
}
