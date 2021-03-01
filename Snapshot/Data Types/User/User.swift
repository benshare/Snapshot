//
//  User.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/17/21.
//

import Foundation

class User: Codable {
    var snapshots: SnapshotCollection
    var hunts: TreasureHuntCollection
    var preferences: UserPreferences
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case snapshots, hunts, preferences
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.snapshots = try container.decode(SnapshotCollection.self, forKey: .snapshots)
        self.hunts = try container.decode(TreasureHuntCollection.self, forKey: .hunts)
        self.preferences = try container.decode(UserPreferences.self, forKey: .preferences)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.snapshots, forKey: .snapshots)
        try container.encode(self.hunts, forKey: .hunts)
        try container.encode(self.preferences, forKey: .preferences)
    }
    
    // MARK: Initialization
    init() {
        self.snapshots = SnapshotCollection()
        self.hunts = TreasureHuntCollection()
        self.preferences = UserPreferences()
    }
}
