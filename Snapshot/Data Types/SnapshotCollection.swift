//
//  SnapshotCollection.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/17/21.
//

import Foundation

class SnapshotCollection {
    var collection: [Snapshot]
    
    init() {
        collection = [Snapshot]()
    }
    
    init(snapshot: Snapshot) {
        collection = [snapshot]
    }
    
    init(snapshots: [Snapshot]) {
        collection = snapshots
    }
    
    func addSnapshot(snapshot: Snapshot) {
        collection.insert(snapshot, at: collection.firstIndex(where: { $0.time > snapshot.time }) ?? collection.endIndex)
    }
    
    func description() -> String {
        var str = ""
        for snapshot in collection {
            str += "Time: \(snapshot.time) - Location: \(snapshot.location) - Title: \(snapshot.title ?? "None") - Has Image: \(snapshot.image != nil)\n"
        }
        return str
    }
}
