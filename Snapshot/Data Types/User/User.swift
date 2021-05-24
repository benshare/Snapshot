//
//  User.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/17/21.
//

import Foundation

enum UserCodingAttributes: String, CodingKey {
    case info, preferences, snapshots, hunts, privateHunts, sharedHunts
}

class User: Codable {
    var info: AccountInfo
    var preferences: UserPreferences
    var snapshots: SnapshotCollection
    var privateHunts: TreasureHuntCollection
    var sharedHunts: TreasureHuntCollection
    
    // MARK: Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingAttributes.self)
        self.info = try container.decode(AccountInfo.self, forKey: .info)
        self.preferences = try container.decode(UserPreferences.self, forKey: .preferences)
        self.snapshots = try container.decode(SnapshotCollection.self, forKey: .snapshots)
        do {
            self.privateHunts = try container.decode(TreasureHuntCollection.self, forKey: .privateHunts)
        } catch {
            self.privateHunts = try container.decode(TreasureHuntCollection.self, forKey: .hunts)
        }
        do {
            self.sharedHunts = try container.decode(TreasureHuntCollection.self, forKey: .sharedHunts)
        } catch {
            self.sharedHunts = TreasureHuntCollection()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserCodingAttributes.self)
        try container.encode(self.info, forKey: .info)
        try container.encode(self.preferences, forKey: .preferences)
        try container.encode(self.snapshots, forKey: .snapshots)
        try container.encode(self.privateHunts, forKey: .privateHunts)
        try container.encode(self.sharedHunts, forKey: .sharedHunts)
    }
    
    // MARK: Initialization
    // Initialize for a new user
    init(username: String) {
        self.info = AccountInfo(username: username)
        self.preferences = UserPreferences()
        self.snapshots = SnapshotCollection()
        self.privateHunts = TreasureHuntCollection()
        self.sharedHunts = TreasureHuntCollection()
    }
}
