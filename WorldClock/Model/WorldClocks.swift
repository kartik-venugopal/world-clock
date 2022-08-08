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
    
    lazy var defaults: UserDefaults = .standard
    
    private let decoder: JSONDecoder = JSONDecoder()
    private lazy var encoder: JSONEncoder = JSONEncoder()
    
    private static let defaultsKey_savedClocks: String = "worldClock.savedClocks"
    private static let defaultsKey_timeFormat: String = "worldClock.timeFormat"
    
    // ---------------------------------------------------------------------------------------------------------
    
    // MARK: init/de-init (UserDefaults persistence)
    
    private init() {
        
        if let savedClocksData = defaults.object(forKey: Self.defaultsKey_savedClocks) as? Data,
           let savedClocks = try? decoder.decode([Clock].self, from: savedClocksData) {
            
            self.clocks = savedClocks
            for clock in self.clocks {
                print("TZIndex: \(clock.zone.index)")
            }
        }
        
        if let savedFormatData = defaults.object(forKey: Self.defaultsKey_timeFormat) as? Data,
           let savedFormat = try? decoder.decode(TimeFormat.self, from: savedFormatData) {
            
            self.format = savedFormat
        }
    }
    
    func save() {
        
        print("\nSaving clocks ...")
        
        for clock in self.clocks {
            print("TZIndex: \(clock.zone.index)")
        }
        
        if let clocksData = try? encoder.encode(clocks) {
            defaults.set(clocksData, forKey: Self.defaultsKey_savedClocks)
        }
        
        if let formatData = try? encoder.encode(format) {
            defaults.set(formatData, forKey: Self.defaultsKey_timeFormat)
        }
    }
    
    deinit {
        save()
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
