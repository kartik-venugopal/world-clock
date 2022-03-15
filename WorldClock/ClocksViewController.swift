//
//  ViewController.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 15/03/22.
//

import Cocoa

class ClocksViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    private let worldClocks: WorldClocks = .shared
    
    private lazy var statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var timeFormatMenu: NSPopUpButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.clockAdded), name: Notification.Name("clockAdded"), object: nil)
        timeFormatMenu.selectItem(withTag: worldClocks.format.rawValue)
    }
    
    @objc func clockAdded() {
        tableView.noteNumberOfRowsChanged()
    }
    
    @objc func quit() {
        NSApp.terminate(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func changeTimeFormatAction(_ sender: NSPopUpButton) {
        
        guard let selectedItem = sender.item(at: sender.indexOfSelectedItem),
              let timeFormat = TimeFormat(rawValue: selectedItem.tag) else {return}
        
        worldClocks.format = timeFormat
    }
    
    @IBAction func removeClocksAction(_ sender: Any) {
        
        let selRows = tableView.selectedRowIndexes.sorted(by: >)
        worldClocks.removeClocks(atIndices: selRows)
        
        tableView.reloadData()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        statusItem.menu = NSMenu()
        
        let item = NSMenuItem(title: "Quit", action: #selector(self.quit), keyEquivalent: "")
        item.target = self
        
        statusItem.menu?.addItem(item)
        
        NSApp.setActivationPolicy(.accessory)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.updateTime()
        }
        
        updateTime()
        
        view.window?.windowController?.close()
    }
    
    private func updateTime() {
        
        let now = Date()
        
        let times = self.worldClocks.clocks.map {$0.time(for: now)}
        let timeStr = times.joined(separator: "  |  ")
        
        self.statusItem.button?.title = timeStr
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        worldClocks.numberOfClocks
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard row >= 0, row < worldClocks.numberOfClocks, let colID = tableColumn?.identifier else {return nil}
        
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

