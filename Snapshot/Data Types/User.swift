//
//  User.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/17/21.
//

import Foundation

class User: Codable {
    var collection: SnapshotCollection
    var preferences: UserPreferences
    
    init() {
        self.collection = SnapshotCollection()
        self.preferences = UserPreferences()
    }
}
