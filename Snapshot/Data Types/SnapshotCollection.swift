//
//  SnapshotCollection.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/17/21.
//

import Foundation

class SnapshotCollection: Codable {
    var collection: [String: Snapshot]
    
    init() {
        collection = [String: Snapshot]()
    }
    
    init(snapshot: Snapshot) {
        collection = [String: Snapshot]()
        collection[snapshot.time.description] = snapshot
    }
    
    init(snapshots: [Snapshot]) {
        collection = [String: Snapshot]()
        for snapshot in snapshots {
            collection[DATE_FORMATS.monthDayYearTime(date: snapshot.time)] = snapshot
        }
    }
    
    func addSnapshot(snapshot: Snapshot) {
        collection[DATE_FORMATS.monthDayYearTime(date: snapshot.time)] = snapshot
    }
    
    func description() -> String {
        var str = ""
        for snapshot in collection.values {
            str += "Time: \(snapshot.time) - Location: \(snapshot.location) - Title: \(snapshot.title ?? "None") - Has Image: \(snapshot.image != nil)\n"
        }
        return str
    }
}
