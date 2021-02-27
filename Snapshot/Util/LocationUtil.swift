//
//  LocationUtil.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/26/21.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
