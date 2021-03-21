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
    private var type: HuntType
    var startingLocation: CLLocationCoordinate2D
    var clues: [Clue]
    var clueRadius: Int
    var allowHints: Bool
    var allowHotterColder: Bool
    private let creator: String
    private var notes: String
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case name, type, startingLocation, clues, clueRadius, allowHints, allowHotterColder, creator, notes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(HuntType.self, forKey: .type)
        self.startingLocation = CLLocationCoordinate2D(location: try container.decode(LocationStruct.self, forKey: .startingLocation))
        self.clues = try container.decode([Clue].self, forKey: .clues)
        self.clueRadius = try container.decode(Int.self, forKey: .clueRadius)
        do {
            self.allowHints = try container.decode(Bool.self, forKey: .allowHints)
        } catch {
            self.allowHints = true
        }
        do {
            self.allowHotterColder = try container.decode(Bool.self, forKey: .allowHotterColder)
        } catch {
            self.allowHotterColder = true
        }
        self.creator = try container.decode(String.self, forKey: .creator)
        self.notes = try container.decode(String.self, forKey: .notes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.type, forKey: .type)
        try container.encode(LocationStruct(location: self.startingLocation), forKey: .startingLocation)
        try container.encode(self.clues, forKey: .clues)
        try container.encode(self.clueRadius, forKey: .clueRadius)
        try container.encode(self.allowHints, forKey: .allowHints)
        try container.encode(self.allowHotterColder, forKey: .allowHotterColder)
        try container.encode(self.creator, forKey: .creator)
        try container.encode(self.notes, forKey: .notes)
    }
    
    // MARK: Initialization
    init() {
        self.name = ""
        self.type = .virtual
        self.startingLocation = CLLocationCoordinate2D(latitude: 37.7873589, longitude: -122.408227)
        self.clues = [Clue]()
        self.clueRadius = 100
        self.allowHints = true
        self.allowHotterColder = true
        self.creator = ""
        self.notes = ""
    }
}
