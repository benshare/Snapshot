//
//  Clue.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/28/21.
//

import Foundation
import UIKit
import CoreLocation

class Clue: Codable {
    var location: CLLocationCoordinate2D
    var image: UIImage?
    var text: String
    var hints: [String]
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case location, image, text, hints
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.location = CLLocationCoordinate2D(location: try container.decode(LocationStruct.self, forKey: .location))
        do {
            self.image = UIImage(data: try container.decode(Data.self, forKey: .image))
        } catch {
            self.image = nil
        }
        self.text = try container.decode(String.self, forKey: .text)
        self.hints = try container.decode([String].self, forKey: .hints)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(LocationStruct(location: self.location), forKey: .location)
        try container.encode(self.image?.pngData(), forKey: .image)
        try container.encode(self.text, forKey: .text)
        try container.encode(self.hints, forKey: .hints)
    }
    
    // MARK: Initialization
    init(location: CLLocationCoordinate2D, image: UIImage? = nil, text: String = "", hints: [String] = [String]()) {
        self.location = location
        self.image = image
        self.text = text
        self.hints = hints
    }
    
    func addHint(hint: String) {
        self.hints.append(hint)
    }
    
    func addHint(hint: String, index: Int) {
        self.hints.insert(hint, at: index)
    }
    
    func removeHint(index: Int) {
        self.hints.remove(at: index)
    }
}
