//
//  Snapshot.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/17/21.
//

import Foundation
import CoreLocation
import UIKit

class Snapshot {
    let location: CLLocationCoordinate2D
    let image: UIImage?
    let time: Date
    let title: String?
    
    init(location: CLLocationCoordinate2D, image: UIImage?, time: Date) {
        self.location = location
        self.image = image
        self.time = time
        self.title = nil
    }
}
