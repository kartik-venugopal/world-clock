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
    
    private lazy var timer: RepeatingTaskExecutor = RepeatingTaskExecutor(intervalMillis: 1000, task: doUpdateDisplayedClocks, queue: .main)
    
    private init() {
        notifCtr.addObserver(self, selector: #selector(clocksUpdated), name: .updateClocks, object: nil)
    }
    
    func showClocksInMenuBar() {
        
        setUpMenuBar()
        
        updateDisplayedClocks()
        
        if worldClocks.numberOfClocks == 0 {
            showSettings()
        }
    }
    
    private func setUpMenuBar() {
        
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
        
        if #available(macOS 11.0, *) {
            
            item1.image = .settingsIcon
            item2.image = .quitIcon
        }
        
        statusItem.menu?.addItems([item1, .separator(), item2])
        NSApp.setActivationPolicy(.accessory)
    }
    
    private func updateDisplayedClocks() {
        
        guard worldClocks.numberOfClocks > 0 else {
        
            timer.pause()
            statusItem.button?.title = "(No clocks configured)"
            return
        }
        
        timer.startOrResume()
        doUpdateDisplayedClocks()
    }
    
    private func doUpdateDisplayedClocks() {
        
        let now = Date()
        
        let times = worldClocks.clocks.map {$0.time(for: now)}
        let timeStr = times.joined(separator: "  |  ")
        
        statusItem.button?.title = timeStr
    }
    
    @objc private func clocksUpdated() {
        
        updateDisplayedClocks()
        worldClocks.save()
    }
    
    @objc func showSettings() {
        
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

extension NSMenu {
    
    func addItems(_ items: [NSMenuItem]) {
        
        items.forEach {
            addItem($0)
        }
    }
}
