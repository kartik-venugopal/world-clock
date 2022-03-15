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
    
    var numberOfClocks: Int {
        clocks.count
    }
    
    private let decoder: JSONDecoder = JSONDecoder()
    private lazy var encoder: JSONEncoder = JSONEncoder()
    
    private static let defaultsKey: String = "worldClock.savedClocks"
    
    private init() {
        
        if let savedClocksData = UserDefaults.standard.object(forKey: Self.defaultsKey) as? Data,
           let savedClocks = try? decoder.decode([Clock].self, from: savedClocksData) {
            
            self.clocks = savedClocks
        }
    }
    
    func addNewClock(_ newClock: Clock) {
        
        clocks.append(newClock)
        
        let notification: Notification = Notification(name: Notification.Name("clockAdded"), object: self, userInfo: ["newClock": newClock])
        NotificationCenter.default.post(notification)
    }
    
    func removeClock(atIndex index: Int) {
        
        if clocks.indices.contains(index) {
            clocks.remove(at: index)
        }
    }
    
    func save() {
        
        if let data = try? encoder.encode(clocks) {
            UserDefaults.standard.set(data, forKey: Self.defaultsKey)
        }
    }
    
    deinit {
        save()
    }
}
