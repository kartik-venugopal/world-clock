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

        notifCtr.addObserver(self, selector: #selector(self.clockAddedOrUpdated), name: Notification.Name("clockAddedOrUpdated"), object: nil)
        timeFormatMenu.selectItem(withTag: worldClocks.format.rawValue)
    }
    
    @objc func clockAddedOrUpdated() {
        
        tableView.reloadData()
        notifCtr.post(name: .updateClocks, object: self)
    }
    
    deinit {
        notifCtr.removeObserver(self)
    }
    
    @IBAction func changeTimeFormatAction(_ sender: NSPopUpButton) {
        
        guard let selectedItem = sender.item(at: sender.indexOfSelectedItem),
              let timeFormat = TimeFormat(rawValue: selectedItem.tag) else {return}
        
        worldClocks.format = timeFormat
        notifCtr.post(name: .updateClocks, object: self)
    }
    
    @IBAction func toggleIndicateDSTAction(_ sender: NSButton) {
        
        worldClocks.indicateDST = sender.state == .on
        notifCtr.post(name: .updateClocks, object: self)
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
        notifCtr.post(name: .updateClocks, object: self)
    }
    
    @IBAction func moveClockUpAction(_ sender: Any) {
        
        let selRow = tableView.selectedRow
        guard selRow >= 1 else {return}

        worldClocks.moveClockUp(at: selRow)
        tableView.reloadData()
        notifCtr.post(name: .updateClocks, object: self)
    }
    
    @IBAction func moveClockDownAction(_ sender: Any) {
        
        let selRow = tableView.selectedRow
        guard selRow >= 0, selRow < worldClocks.numberOfClocks - 1 else {return}

        worldClocks.moveClockDown(at: selRow)
        tableView.reloadData()
        notifCtr.post(name: .updateClocks, object: self)
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
        
        guard row >= 0, row < worldClocks.numberOfClocks else {return nil}
        
        let clock = worldClocks.clocks[row]
        
        switch colID {
            
        case .clockName:
            
            cell.text = clock.name
            
        case .clockLocation:
            
            cell.text = clock.zone.location
            
        case .clockOffset:
            
            cell.text = clock.zone.humanReadableOffset
            
        case .clockIsDST:
            
            cell.text = clock.zone.isDST(for: Date()) ? "Yes" : "No"
            
        case .clockNextDSTTransition:
            
            cell.text = clock.zone.nextDSTTransitionString ?? "-"
            
        default:
            
            return nil
        }
        
        return cell
    }
}

private extension NSUserInterfaceItemIdentifier {
    
    static let clockName: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier("clock_name")
    static let clockLocation: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier("clock_location")
    static let clockOffset: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier("clock_offset")
    static let clockIsDST: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier("clock_isDST")
    static let clockNextDSTTransition: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier("clock_nextDSTTransition")
}

private extension NSTableCellView {
    
    var text: String? {
        
        get {textField?.stringValue}
        set {textField?.stringValue = newValue ?? ""}
    }
}
