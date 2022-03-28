//
//  ViewController.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 15/03/22.
//

import Cocoa

class ClocksViewController: NSViewController {
    
    private let worldClocks: WorldClocks = .shared
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var timeFormatMenu: NSPopUpButton!
    
    private let clockEditContext: ClockEditContext = .shared

    override func viewDidLoad() {
        
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.clockAddedOrUpdated), name: Notification.Name("clockAddedOrUpdated"), object: nil)
        timeFormatMenu.selectItem(withTag: worldClocks.format.rawValue)
    }
    
    @objc func clockAddedOrUpdated() {
        
        tableView.reloadData()
        NotificationCenter.default.post(name: Notification.Name("updateClocks"), object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func changeTimeFormatAction(_ sender: NSPopUpButton) {
        
        guard let selectedItem = sender.item(at: sender.indexOfSelectedItem),
              let timeFormat = TimeFormat(rawValue: selectedItem.tag) else {return}
        
        worldClocks.format = timeFormat
        NotificationCenter.default.post(name: Notification.Name("updateClocks"), object: self)
    }
    
    @IBAction func editClockAction(_ sender: Any) {
        
        let selRow = tableView.selectedRow
        guard selRow >= 0 else {return}
        
        clockEditContext.clock = worldClocks.clocks[selRow]
        performSegue(withIdentifier: "EditClockSegue", sender: self)
    }
    
    @IBAction func removeClocksAction(_ sender: Any) {
        
        let selRows = tableView.selectedRowIndexes.sorted(by: >)
        worldClocks.removeClocks(atIndices: selRows)
        
        tableView.reloadData()
        NotificationCenter.default.post(name: Notification.Name("updateClocks"), object: self)
    }
    
    @IBAction func moveClockUpAction(_ sender: Any) {
        
        let selRow = tableView.selectedRow
        guard selRow >= 1 else {return}

        worldClocks.moveClockUp(at: selRow)
        tableView.reloadData()
        NotificationCenter.default.post(name: Notification.Name("updateClocks"), object: self)
    }
    
    @IBAction func moveClockDownAction(_ sender: Any) {
        
        let selRow = tableView.selectedRow
        guard selRow >= 0, selRow < worldClocks.numberOfClocks - 1 else {return}

        worldClocks.moveClockDown(at: selRow)
        tableView.reloadData()
        NotificationCenter.default.post(name: Notification.Name("updateClocks"), object: self)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        view.window?.windowController?.close()
        NSApp.setActivationPolicy(.accessory)
    }
}

extension ClocksViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        worldClocks.numberOfClocks
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard worldClocks.clocks.indices.contains(row), let colID = tableColumn?.identifier else {return nil}
        
        guard let cell = tableView.makeView(withIdentifier: colID, owner: nil) as? NSTableCellView else {return nil}
        
        let clock = worldClocks.clocks[row]
        
        switch colID.rawValue {
            
        case "clock_name":
            
            cell.textField?.stringValue = clock.name
            
        case "clock_location":
            
            cell.textField?.stringValue = clock.zone.location
            
        case "clock_offset":
            
            cell.textField?.stringValue = clock.zone.humanReadableOffset
            
        case "clock_dst":
            
            cell.textField?.stringValue = clock.zone.isDST ? "Yes" : "No"
            
        default:
            
            return nil
        }
        
        return cell
    }
}
