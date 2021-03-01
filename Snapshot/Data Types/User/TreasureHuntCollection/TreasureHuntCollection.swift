//
//  TreasureHuntCollection.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/28/21.
//

import Foundation

class TreasureHuntCollection: Codable {
    let hunts: [TreasureHunt]
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case hunts
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hunts = try container.decode([TreasureHunt].self, forKey: .hunts)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.hunts, forKey: .hunts)
    }
    init() {
        self.hunts = [TreasureHunt]()
    }
}
