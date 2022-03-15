//
//  AddClockViewController.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 16/03/22.
//

import AppKit

class AddClockViewController: NSViewController, NSMenuDelegate {
    
    @IBOutlet weak var zonesList: NSPopUpButton!
    @IBOutlet weak var txtZoneName: NSTextField!
    
    private var selectedZone: WCTimeZone!
    
    private let worldClocks: WorldClocks = .shared
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        zonesList.menu?.removeAllItems()
        
        for zone in WCTimeZone.allTimeZones {
            zonesList.menu?.addItem(withTitle: zone.description, action: nil, keyEquivalent: "")
        }
        
        selectedZone = WCTimeZone.allTimeZones[0]
        
        let location = selectedZone.location
        let split = location.split(separator: "/")
        let name = split.count >= 2 ? String(split.last!) : location
        
        txtZoneName.stringValue = name
    }
    
    @IBAction func zoneSelectionAction(_ sender: NSPopUpButton) {
        
        let zoneIndex = sender.indexOfSelectedItem
        guard WCTimeZone.allTimeZones.indices.contains(zoneIndex) else {return}
        
        let zone = WCTimeZone.allTimeZones[zoneIndex]
        self.selectedZone = zone
        
        let location = zone.location
        let split = location.split(separator: "/")
        let name = split.count >= 2 ? String(split.last!) : location
        
        txtZoneName.stringValue = name
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        view.window?.windowController?.close()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        let newClock = Clock(zone: selectedZone, name: txtZoneName.stringValue)
        worldClocks.addNewClock(newClock)
        
        let notification: Notification = Notification(name: Notification.Name("clockAdded"), object: self, userInfo: ["newClock": newClock])
        NotificationCenter.default.post(notification)
        
        view.window?.windowController?.close()
    }
}
