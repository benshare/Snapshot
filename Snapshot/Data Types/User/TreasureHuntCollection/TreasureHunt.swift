//
//  TreasureHunt.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/28/21.
//

import Foundation
import UIKit
import MapKit

enum HuntType: Int, Codable {
    case realWorld, virtual
}

class TreasureHunt: Codable {
    var name: String
    private let creator: String
    private var type: HuntType
    var clues: [Clue]
    private var region: MKCoordinateRegion
    private var notes: String
    var clueRadius: Double
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case name, creator, type, clues, region, notes, clueRadius
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.creator = try container.decode(String.self, forKey: .creator)
        self.type = try container.decode(HuntType.self, forKey: .type)
        self.clues = try container.decode([Clue].self, forKey: .clues)
        self.region = MKCoordinateRegion(region: try container.decode(RegionStruct.self, forKey: .region))
        self.notes = try container.decode(String.self, forKey: .notes)
        self.clueRadius = try container.decode(Double.self, forKey: .clueRadius)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.creator, forKey: .creator)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.clues, forKey: .clues)
        try container.encode(RegionStruct(region: self.region), forKey: .region)
        try container.encode(self.notes, forKey: .notes)
        try container.encode(self.clueRadius, forKey: .clueRadius)
    }
    
    // MARK: Initialization
    init() {
        self.name = ""
        self.creator = ""
        self.type = .virtual
        self.clues = [Clue]()
        self.region = MKCoordinateRegion()
        self.notes = ""
        self.clueRadius = 100
    }
}
