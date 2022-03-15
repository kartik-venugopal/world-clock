//
//  AppDelegate.swift
//  WorldClock
//
//  Created by Kartik Venugopal on 15/03/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
//        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
//        statusItem.menu = NSMenu()
//        statusItem.menu?.addItem(NSMenuItem(title: "Quit", action: #selector(self.quit), keyEquivalent: ""))
//
////        NSApp.setActivationPolicy(.accessory)
//
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
//
//            let now = Date()
//            let timeStr = self.clock.time(for: now)
//            self.statusItem.button?.title = timeStr
//            print("TimeStr: \(timeStr)")
//
//            self.clock.format = .hoursMinutes_24hour
//        }
        
//        parseHTML()
    }
    
//    func parseHTML() {
//        
//        let contents = try! String(contentsOf: URL(fileURLWithPath: "/Users/kven/timeZones.html")).replacingOccurrences(of: "−", with: "-")
//        let doc: Document = try! SwiftSoup.parse(contents)
//        
//        let table = doc.body()!.children().first()!
//        let tbody = table.children().first()!
//        let rows = tbody.children().filter({$0.nodeName() == "tr"})
//        
//        var zones: [WCTimeZone] = []
//        
//        for row in rows {
//            
//            let cols = row.children()
//            
//            let location = try! cols[1].text()
//            let offset = try! cols[4].text()
//            let dstOffset = try! cols[5].text()
//            
//            let offsetTokens = offset.split(separator: ":")
//            let hrs = String(offsetTokens[0])
//            let mins = String(offsetTokens[1])
//            
//            guard let offsetHrs = Int(hrs), let offsetMins = Int(mins) else {continue}
//            
//            zones.append(WCTimeZone(location: location, offsetHours: offsetHrs, offsetMins: offsetMins, isDST: false))
//            
//            if dstOffset != offset {
//                
//                let dstOffsetTokens = dstOffset.split(separator: ":")
//                let dstHrs = dstOffsetTokens[0]
//                let dstMins = dstOffsetTokens[1]
//                
//                guard let dstOffsetHrs = Int(dstHrs), let dstOffsetMins = Int(dstMins) else {continue}
//                zones.append(WCTimeZone(location: location, offsetHours: dstOffsetHrs, offsetMins: dstOffsetMins, isDST: true))
//                
//            }
//        }
//        
//        print(zones.count)
//        
//        for zone in zones.sorted(by: {
//            
//            var z0 = $0
//            var z1 = $1
//            
//            if z0.offsetAsSeconds < z1.offsetAsSeconds {
//                return true
//            }
//            
//            if z0.offsetAsSeconds > z1.offsetAsSeconds {
//                return false
//            }
//            
//            return z0.location < z1.location
//                
//        }) {
//            print("WCTimeZone(location: \"\(zone.location)\", offsetHours: \(zone.offsetHours), offsetMins: \(zone.offsetMins), isDST: \(zone.isDST)),")
//        }
//    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        WorldClocks.shared.save()
    }

    func parseCSV() {
        
//        var contents = try! String(contentsOf: URL(fileURLWithPath: "/Users/kven/zone.csv"))
//
//        var lines = contents.split(separator: "\n")
//
//        var temp: [Int: String] = [:]
//        var map: [Int: [WCTimeZone]] = [:]
//
//        for line in lines {
//
//            let line = line.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "_", with: " ")
//            let columns = line.split(separator: ",")
//
//            guard let id: Int = Int(columns[0]) else {continue}
//
//            let location = String(columns[2])
//            temp[id] = location
//            map[id] = []
//        }
//
//        contents = try! String(contentsOf: URL(fileURLWithPath: "/Users/kven/timezone.csv"))
//
//        lines = contents.split(separator: "\n")
//
//        for line in lines {
//
//            let line = line.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "_", with: " ")
//            let columns = line.split(separator: ",")
//
//            if line.contains("GMT") {continue}
//
//            guard let id: Int = Int(columns[0]) else {continue}
//
//            let abbr = String(columns[1])
//
//            guard let offset = Int(columns[3]) else {continue}
//            let isDST = String(columns[4]) == "1"
//            let location = temp[id]!
//
//            if offset % 1800 != 0 {continue}
//
//            guard var arrForId = map[id] else {continue}
//
//            if arrForId.count >= 2 {
//
//                if arrForId.contains(where: {$0.isDST}) && arrForId.contains(where: {!$0.isDST}) {
//                    continue
//                }
//            }
//
//            let newTZ = WCTimeZone(id: id, location: location, abbreviation: abbr, offset: offset, isDST: isDST)
//            arrForId.append(newTZ)
//
//            map[id] = arrForId
//        }
//
//        var allTZs: [WCTimeZone] = []
//
//        for (id, tzs) in map {
//
//            var arr: [WCTimeZone] = []
//
//            if let noDSTTZ = tzs.first(where: {!$0.isDST}) {
//                arr.append(noDSTTZ)
//            }
//
//            if let dstTZ = tzs.first(where: {$0.isDST}) {
//                arr.append(dstTZ)
//            }
//
//            map[id] = arr
//
//            allTZs += arr
//        }
//
//        allTZs.append(WCTimeZone(id: 0, location: "Europe/London", abbreviation: "GMT", offset: 0, isDST: false))
//
//        for tz in allTZs.sorted(by: {
//
//            if $0.offset < $1.offset {
//                return true
//            }
//
//            if $0.offset > $1.offset {
//                return false
//            }
//
//            return $0.location < $1.location
//
//        }) {
//            print(tz)
//        }
//
//        print("Found \(map.count), \(map.values.reduce(0, {(acc: Int, newSet: [WCTimeZone]) -> Int in acc + newSet.count}))")
    }
}

