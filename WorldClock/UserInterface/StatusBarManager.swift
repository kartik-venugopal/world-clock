//
//  StatusBarManager.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 08/08/22.
//

import Foundation
import AppKit

class StatusBarManager {
    
    static let shared: StatusBarManager = .init()
    
    private lazy var statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    private lazy var settingsWindowController: NSWindowController? = NSStoryboard(name: "Main", bundle: nil)
        .instantiateController(withIdentifier: "SettingsWindowController") as? NSWindowController
    
    private lazy var appVersion: String? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    private init() {
        notifCtr.addObserver(self, selector: #selector(clocksUpdated), name: .updateClocks, object: nil)
    }
    
    func showClocksInMenuBar() {
        
        if let appVersion = self.appVersion {
            statusItem.toolTip = "World Clock v\(appVersion)"
        } else {
            statusItem.toolTip = "World Clock"
        }
        
        statusItem.menu = NSMenu()
        
        let item1 = NSMenuItem(title: "Settings", action: #selector(showSettings), keyEquivalent: "")
        item1.target = self
        
        let item2 = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "")
        item2.target = self
        
        statusItem.menu?.addItem(item1)
        statusItem.menu?.addItem(NSMenuItem.separator())
        statusItem.menu?.addItem(item2)
        
        NSApp.setActivationPolicy(.accessory)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.updateClocks()
        }
        
        updateClocks()
        
        if worldClocks.numberOfClocks == 0 {
            showSettings()
        }
    }
    
    @objc private func clocksUpdated() {
        
        updateClocks()
        worldClocks.save()
    }
    
    private func updateClocks() {
        
        guard worldClocks.numberOfClocks > 0 else {
        
            statusItem.button?.title = "(No clocks configured)"
            return
        }
        
        let now = Date()
        
        let times = worldClocks.clocks.map {$0.time(for: now)}
        let timeStr = times.joined(separator: "  |  ")
        
        statusItem.button?.title = timeStr
    }
    
    @objc func showSettings() {
        
        NSApp.setActivationPolicy(.regular)
        
        guard let settingsWindowController = settingsWindowController else {return}
        settingsWindowController.showWindow(self)
        
        // HACK - Because of an Apple bug, the main menu will not be usable until the app loses and then regains focus.
        // The following code simulates the user action of activating another app and then activating this app after a
        // short time interval.
        NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.dock").first?.activate(options: [])

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            NSApp.activate(ignoringOtherApps: true)
        })
    }
    
    @objc func quit() {
        NSApp.terminate(self)
    }
}
