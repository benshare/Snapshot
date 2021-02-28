//
//  Snapshot.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/17/21.
//

import Foundation
import CoreLocation
import UIKit

class Snapshot: Codable {
    let id: Int
    let location: CLLocationCoordinate2D
    var image: UIImage?
    let time: Date
    var title: String?
    var information: String?
    
    // MARK: Codable
    enum CodingKeys: String, CodingKey {
        case id, location, image, time, title, information
    }
    
    struct Loc: Codable {
        let latitude: Double
        let longitude: Double
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        let loc = try container.decode(Loc.self, forKey: .location)
        self.location = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
        do {
            self.image = UIImage(data: try container.decode(Data.self, forKey: .image))
        } catch {
            self.image = nil
        }
        self.time = try container.decode(Date.self, forKey: .time)
        self.title = try container.decode(String?.self, forKey: .title)
        self.information = try container.decode(String.self, forKey: .information)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(Loc(latitude: self.location.latitude, longitude: self.location.longitude), forKey: .location)
        try container.encode(self.image?.pngData(), forKey: .image)
        try container.encode(self.time, forKey: .time)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.information, forKey: .information)
    }
    
    // MARK: Initialization
    init(id: Int, location: CLLocationCoordinate2D, image: UIImage?, time: Date) {
        self.id = id
        self.location = location
        self.image = image
        self.time = time
        self.title = nil
        self.information = ""
    }
}
