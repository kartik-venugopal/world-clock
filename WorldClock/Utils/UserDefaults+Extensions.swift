//
//  JSONReaderWriter.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 08/08/22.
//

import Foundation

private let decoder: JSONDecoder = JSONDecoder()
private let encoder: JSONEncoder = JSONEncoder()

extension UserDefaults {
 
    func decode<T: Codable>(_ type: T.Type, mappedToKey defaultsKey: String) -> T? {
        
        if let data = defaults.object(forKey: defaultsKey) as? Data {
            return try? decoder.decode(T.self, from: data)
        }
        
        return nil
    }
    
    func encode<T: Codable>(_ object: T, mappedToKey defaultsKey: String) {
        
        if let encodedData = try? encoder.encode(object) {
            defaults.set(encodedData, forKey: defaultsKey)
        }
    }
}
