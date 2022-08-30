//
//  ClockEditorViewController.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 16/03/22.
//

import AppKit

class ClockEditorViewController: NSViewController, NSMenuDelegate {
    
    @IBOutlet weak var radioBtnSelectTimeZone: NSButton!
    @IBOutlet weak var radioBtnSpecifyGMTOffset: NSButton!
    
    @IBOutlet weak var zonesList: NSPopUpButton!
    @IBOutlet weak var zonesListMenu: NSMenu!
    @IBOutlet weak var txtZoneName: NSTextField!
    
    @IBOutlet weak var offsetStepper: NSStepper!
    @IBOutlet weak var txtOffset: NSTextField!
    
    private var selectedZone: WCTimeZone!
    
    private let worldClocks: WorldClocks = .shared
    
    private let clockEditContext: ClockEditContext = .shared
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // TODO: Load the zones into the menu immediately upon app startup ? Faster ?
        
        zonesListMenu.removeAllItems()
        
        for zone in WCTimeZone.allTimeZones {
            zonesListMenu.addItem(withTitle: zone.description, action: nil, keyEquivalent: "")
        }
        
        if let editedClock = clockEditContext.clock {
            
            selectedZone = editedClock.zone
            zonesList.selectItem(at: editedClock.zone.index)
            txtZoneName.stringValue = editedClock.name
            
        } else {
            
            selectedZone = WCTimeZone.allTimeZones[0]
            txtZoneName.stringValue = selectedZone.city
        }
    }
    
    ///
    /// Update the window title depending on add / edit mode.
    ///
    override func viewWillAppear() {
        
        if let editedClock = clockEditContext.clock {
            windowTitle = "Edit Clock '\(editedClock.name)'"
            
        } else {
            windowTitle = "Add a Clock"
        }
        
        modeSelectionAction(self)
    }
    
    /// Select standard time zone / specify GMT offset
    @IBAction func modeSelectionAction(_ sender: Any) {
        
        zonesList.enableIf(radioBtnSelectTimeZone.state == .on)
        offsetStepper.enableIf(radioBtnSpecifyGMTOffset.state == .on)
        txtOffset.enableIf(radioBtnSpecifyGMTOffset.state == .on)
    }
    
    @IBAction func zoneSelectionAction(_ sender: NSPopUpButton) {
        
        let zoneIndex = sender.indexOfSelectedItem
        guard WCTimeZone.allTimeZones.indices.contains(zoneIndex) else {return}
        
        selectedZone = WCTimeZone.allTimeZones[zoneIndex]
        txtZoneName.stringValue = selectedZone.city
    }
    
    @IBAction func offsetStepperAction(_ sender: Any) {
        
        let minsTotal = offsetStepper.integerValue
        let negative = minsTotal < 0
        let absMinsTotal = abs(minsTotal)
        
        let hours = absMinsTotal / 60
        let mins = absMinsTotal - (hours * 60)
        
        txtOffset.stringValue = "GMT\(negative ? "-" : "+")\(hours):\(String(format: "%02d", mins))"
    }
    
    private lazy var clockAddedOrUpdatedNotification = Notification(name: .clockAddedOrUpdated, object: self, userInfo: nil)
    
    @IBAction func saveAction(_ sender: Any) {
        
        if let editedClock = clockEditContext.clock {
            
            // Edit the clock
            let zoneIndex = zonesList.indexOfSelectedItem
            guard WCTimeZone.allTimeZones.indices.contains(zoneIndex) else {
                
                // TODO: Display an error alert ? "Something went wrong: Time Zone with index \(zoneIndex) not found."
                return
            }
            
            editedClock.zone = WCTimeZone.allTimeZones[zoneIndex]
            editedClock.name = txtZoneName.stringValue
            
            clockEditContext.clear()
            
        } else {
            
            // Add a new clock
            worldClocks.addNewClock(Clock(zone: selectedZone, name: txtZoneName.stringValue))
        }
        
        notifCtr.post(clockAddedOrUpdatedNotification)
        
        closeWindow()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        clockEditContext.clear()
        closeWindow()
    }
}

extension NSViewController {
    
    var windowTitle: String? {
        
        get {
            view.window?.title
        }
        
        set {
            view.window?.title = newValue ?? ""
        }
    }
    
    func closeWindow() {
        view.window?.windowController?.close()
    }
}
