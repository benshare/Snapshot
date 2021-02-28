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
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case collection, preferences
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.collection = try container.decode(SnapshotCollection.self, forKey: .collection)
        self.preferences = try container.decode(UserPreferences.self, forKey: .preferences)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.collection, forKey: .collection)
        try container.encode(self.preferences, forKey: .preferences)
    }
    
    // MARK: Initialization
    init() {
        self.collection = SnapshotCollection()
        self.preferences = UserPreferences()
    }
}
