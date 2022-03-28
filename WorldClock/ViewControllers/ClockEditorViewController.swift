//
//  ClockEditorViewController.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 16/03/22.
//

import AppKit

class ClockEditorViewController: NSViewController, NSMenuDelegate {
    
    @IBOutlet weak var zonesList: NSPopUpButton!
    @IBOutlet weak var txtZoneName: NSTextField!
    
    private var selectedZone: WCTimeZone!
    
    private let worldClocks: WorldClocks = .shared
    
    private let clockEditContext: ClockEditContext = .shared
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        zonesList.menu?.removeAllItems()
        
        for zone in WCTimeZone.allTimeZones {
            zonesList.menu?.addItem(withTitle: zone.description, action: nil, keyEquivalent: "")
        }
        
        if let editedClock = clockEditContext.clock {
        
            selectedZone = editedClock.zone
            zonesList.selectItem(at: editedClock.zone.index)
            txtZoneName.stringValue = editedClock.name
            
        } else {
            
            selectedZone = WCTimeZone.allTimeZones[0]
            txtZoneName.stringValue = selectedZone.humanReadableLocation
        }
    }
    
    @IBAction func zoneSelectionAction(_ sender: NSPopUpButton) {
        
        let zoneIndex = sender.indexOfSelectedItem
        guard WCTimeZone.allTimeZones.indices.contains(zoneIndex) else {return}
        
        let zone = WCTimeZone.allTimeZones[zoneIndex]
        self.selectedZone = zone
        txtZoneName.stringValue = selectedZone.humanReadableLocation
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        clockEditContext.clear()
        view.window?.windowController?.close()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        if let editedClock = clockEditContext.clock {
            
            // Edit the clock
            
            editedClock.zone = WCTimeZone.allTimeZones[zonesList.indexOfSelectedItem]
            editedClock.name = txtZoneName.stringValue
            
            clockEditContext.clear()
            
        } else {
            
            // Add a new clock
            
            let newClock = Clock(zone: selectedZone, name: txtZoneName.stringValue)
            worldClocks.addNewClock(newClock)
        }
        
        let notification: Notification = Notification(name: Notification.Name("clockAddedOrUpdated"), object: self, userInfo: nil)
        NotificationCenter.default.post(notification)
        
        view.window?.windowController?.close()
    }
}
