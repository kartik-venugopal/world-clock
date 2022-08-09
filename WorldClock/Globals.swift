//
//  Globals.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 08/08/22.
//

import Foundation

/// Used to read/write global (app-level) settings.
let defaults: UserDefaults = .standard

/// Used to send and respond to notifications.
let notifCtr: NotificationCenter = .default

/// Singleton of 'WorldClocks'
let worldClocks: WorldClocks = .shared

let statusBarManager: StatusBarManager = .shared

extension Notification.Name {
    
    static let updateClocks: Notification.Name = Notification.Name("updateClocks")
    static let clockAddedOrUpdated: Notification.Name = Notification.Name("clockAddedOrUpdated")
}
