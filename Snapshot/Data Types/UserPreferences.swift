//
//  UserPreferences.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/19/21.
//

import Foundation

enum SnapshotSource: Int, Codable {
    enum CodingKeys: String, CodingKey {
        case value
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self = try container.decode(SnapshotSource.self, forKey: .value)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self, forKey: .value)
//    }
    
    case camera, library
}

class UserPreferences: Codable {
    var defaultSource: SnapshotSource
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case defaultSource
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.defaultSource = try container.decode(SnapshotSource.self, forKey: .defaultSource)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.defaultSource, forKey: .defaultSource)
    }
    
    // MARK: Initialization
    required init() {
        defaultSource = .camera
    }
}
