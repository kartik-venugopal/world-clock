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
    
    @IBOutlet weak var btnAddClock: NSButton!
    @IBOutlet weak var btnRemoveClocks: NSButton!
    @IBOutlet weak var btnEditClock: NSButton!
    @IBOutlet weak var btnMoveClockUp: NSButton!
    @IBOutlet weak var btnMoveClockDown: NSButton!
    
    private let clockEditContext: ClockEditContext = .shared
    
    private lazy var timer: RepeatingTaskExecutor = RepeatingTaskExecutor(intervalMillis: 1000, task: updateTableDSTInfo, queue: .main)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        notifCtr.addObserver(self, selector: #selector(self.clockAddedOrUpdated), name: .clockAddedOrUpdated, object: nil)
        timeFormatMenu.selectItem(withTag: worldClocks.format.rawValue)
    }
    
    override func viewWillAppear() {

        super.viewWillAppear()
        updateButtonStates()
        
        checkIfDSTInfoUpdateIsNecessary()
    }
    
    override func viewDidDisappear() {

        super.viewDidDisappear()
        timer.pause()
    }
    
    private func checkIfDSTInfoUpdateIsNecessary() {
        hasClockThatUsesDST ? timer.startOrResume() : timer.pause()
    }
    
    private var hasClockThatUsesDST: Bool {
        
        for zone in worldClocks.clocks.map({$0.zone}) {
            
            if zone.usesDST {
                return true
            }
        }
        
        return false
    }
    
    private func updateTableDSTInfo() {
        
        let rowsThatUseDST: [Int] = worldClocks.clocks.map {$0.zone}.enumerated().filter {$1.usesDST}.map {$0.offset}
        tableView.reloadData(forRowIndexes: IndexSet(rowsThatUseDST), columnIndexes: IndexSet([3, 4]))
    }
    
    @objc func clockAddedOrUpdated() {
        
        tableView.reloadData()
        notifCtr.post(name: .updateClocks, object: self)
        checkIfDSTInfoUpdateIsNecessary()
    }
    
    func updateButtonStates() {
        
        switch tableView.numberOfSelectedRows {
            
        case 0:
            
            [btnRemoveClocks, btnEditClock, btnMoveClockUp, btnMoveClockDown].forEach {$0?.disable()}
            
        case 1:
            
            let selRow = tableView.selectedRow
            btnMoveClockUp.enableIf(selRow > 0)
            btnMoveClockDown.enableIf(selRow < (tableView.numberOfRows - 1))
            
            [btnRemoveClocks, btnEditClock].forEach {$0?.enable()}
            
        default:
            
            btnRemoveClocks.enable()
            [btnEditClock, btnMoveClockUp, btnMoveClockDown].forEach {$0?.disable()}
        }
    }
    
    deinit {
        notifCtr.removeObserver(self)
    }
    
    // ----------------------------------------------------------------------------------------------------------------
    
    // MARK: Actions
    
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
        updateButtonStates()
        checkIfDSTInfoUpdateIsNecessary()
        
        notifCtr.post(name: .updateClocks, object: self)
    }
    
    @IBAction func moveClockUpAction(_ sender: Any) {
        
        let selRow = tableView.selectedRow
        guard selRow >= 1 else {return}

        worldClocks.moveClockUp(at: selRow)
        tableView.reloadData(andSelectRow: selRow - 1)
        
        notifCtr.post(name: .updateClocks, object: self)
    }
    
    @IBAction func moveClockDownAction(_ sender: Any) {
        
        let selRow = tableView.selectedRow
        guard selRow >= 0, selRow < worldClocks.numberOfClocks - 1 else {return}

        worldClocks.moveClockDown(at: selRow)
        tableView.reloadData(andSelectRow: selRow + 1)
        
        notifCtr.post(name: .updateClocks, object: self)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        closeWindow()
    }
}

extension NSControl {
    
    var isDisabled: Bool {!isEnabled}
    
    @objc func enable() {
        self.isEnabled = true
    }
    
    @objc func disable() {
        self.isEnabled = false
    }
    
    @objc func enableIf(_ condition: Bool) {
        self.isEnabled = condition
    }
    
    @objc func disableIf(_ condition: Bool) {
        self.isEnabled = !condition
    }
}

extension NSTableView {
    
    func selectRow(_ row: Int) {
        selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
    }
    
    func reloadData(andSelectRow row: Int) {
        
        reloadData()
        selectRow(row)
    }
}
