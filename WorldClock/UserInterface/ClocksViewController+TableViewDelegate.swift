//
//  ClocksViewController+TableViewDelegate.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 09/08/22.
//

import AppKit

extension ClocksViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    // Enables type selection, allowing the user to conveniently and efficiently find a playlist track by typing its display name, which results in the track, if found, being selected within the playlist
    func tableView(_ tableView: NSTableView, typeSelectStringFor tableColumn: NSTableColumn?, row: Int) -> String? {
        
        guard worldClocks.clocks.indices.contains(row), let colID = tableColumn?.identifier else {return nil}
        
        // Only the track name column is used for type selection
        switch colID {
            
        case .clockName:
            
            return worldClocks.clocks[row].name
            
        case .clockLocation:
            
            return worldClocks.clocks[row].zone.location
            
        default:
            
            return nil
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        worldClocks.numberOfClocks
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard worldClocks.clocks.indices.contains(row), let colID = tableColumn?.identifier else {return nil}
        
        guard let cell = tableView.makeView(withIdentifier: colID, owner: nil) as? NSTableCellView else {return nil}
        
        let clock = worldClocks.clocks[row]
        
        switch colID {
            
        case .clockName:
            
            cell.text = clock.name
            
        case .clockLocation:
            
            cell.text = clock.zone.humanReadableLocation
            
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
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateButtonStates()
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
