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
    
    var numberOfClocks: Int {
        clocks.count
    }
    
    lazy var defaults: UserDefaults = .standard
    
    private let decoder: JSONDecoder = JSONDecoder()
    private lazy var encoder: JSONEncoder = JSONEncoder()
    
    private static let defaultsKey_savedClocks: String = "worldClock.savedClocks"
    private static let defaultsKey_timeFormat: String = "worldClock.timeFormat"
    
    private init() {
        
        if let savedClocksData = defaults.object(forKey: Self.defaultsKey_savedClocks) as? Data,
           let savedClocks = try? decoder.decode([Clock].self, from: savedClocksData) {
            
            self.clocks = savedClocks
            
        }
        
        if let savedFormatData = defaults.object(forKey: Self.defaultsKey_timeFormat) as? Data,
           let savedFormat = try? decoder.decode(TimeFormat.self, from: savedFormatData) {
            
            self.format = savedFormat
        }
    }
    
    func addNewClock(_ newClock: Clock) {
        clocks.append(newClock)
    }
    
    func removeClocks(atIndices indices: [Int]) {
        
        for index in indices.sorted(by: >) {
            clocks.remove(at: index)
        }
    }
    
    func save() {
        
        if let data = try? encoder.encode(clocks) {
            defaults.set(data, forKey: Self.defaultsKey_savedClocks)
        }
        
        if let data = try? encoder.encode(format) {
            defaults.set(data, forKey: Self.defaultsKey_timeFormat)
        }
    }
    
    deinit {
        save()
    }
}
