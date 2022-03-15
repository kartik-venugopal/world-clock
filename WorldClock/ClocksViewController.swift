//
//  ViewController.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 15/03/22.
//

import Cocoa

class ClocksViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    private let worldClocks: WorldClocks = .shared
    
    @IBOutlet weak var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.clockAdded), name: Notification.Name("clockAdded"), object: nil)
    }
    
    @objc func clockAdded() {
        tableView.noteNumberOfRowsChanged()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

