//
//  AppDelegate.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 15/03/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let worldClocks: WorldClocks = .shared

    private lazy var statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    private lazy var settingsWindowController: NSWindowController? = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "SettingsWindowController") as? NSWindowController

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        showClocksInMenuBar()
        
        if worldClocks.numberOfClocks == 0 {
            showSettings()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        WorldClocks.shared.save()
    }
    
    @objc func showClocksInMenuBar() {
        
        statusItem.menu = NSMenu()
        
        let item1 = NSMenuItem(title: "Settings", action: #selector(self.showSettings), keyEquivalent: "")
        item1.target = self
        
        let item2 = NSMenuItem(title: "Quit", action: #selector(self.quit), keyEquivalent: "")
        item2.target = self
        
        statusItem.menu?.addItem(item1)
        statusItem.menu?.addItem(NSMenuItem.separator())
        statusItem.menu?.addItem(item2)
        
        NSApp.setActivationPolicy(.accessory)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.updateTime()
        }
        
        updateTime()
    }
    
    private func updateTime() {
        
        guard worldClocks.numberOfClocks > 0 else {
        
            self.statusItem.button?.title = "(No clocks configured)"
            return
        }
        
        let now = Date()
        
        let times = worldClocks.clocks.map {$0.time(for: now)}
        let timeStr = times.joined(separator: "  |  ")
        
        self.statusItem.button?.title = timeStr
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

