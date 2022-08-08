//
//  AppDelegate.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 15/03/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        worldClocks.load()
        statusBarManager.showClocksInMenuBar()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        worldClocks.save()
    }
}
