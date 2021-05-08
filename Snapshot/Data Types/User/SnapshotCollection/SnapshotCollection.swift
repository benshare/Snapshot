//
//  SnapshotCollection.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/17/21.
//

import Foundation

class SnapshotCollection: Codable {
    var collection: [Int: Snapshot]
    var nextId: Int
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case collection, nextId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.collection = try container.decode([Int: Snapshot].self, forKey: .collection)
        self.nextId = try container.decode(Int.self, forKey: .nextId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.collection, forKey: .collection)
        try container.encode(self.collection, forKey: .collection)
        try container.encode(self.nextId, forKey: .nextId)
    }
    
    // MARK: Initialization
    init() {
        collection = [Int: Snapshot]()
        nextId = 0
    }
    
    func addSnapshot(snapshot: Snapshot) {
        collection[nextId] = snapshot
        nextId += 1
    }
    
    func removeSnapshot(index: Int) {
        collection.removeValue(forKey: index)
    }
    
    func description() -> String {
        var str = ""
        for snapshot in collection.values {
            str += "Time: \(snapshot.time) - Location: \(snapshot.location) - Title: \(snapshot.title ?? "None") - Has Image: \(snapshot.image != nil)\n"
        }
        return str
    }
}
