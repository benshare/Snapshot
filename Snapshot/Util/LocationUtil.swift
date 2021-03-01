//
//  LocationUtil.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/26/21.
//

import Foundation
import MapKit

struct LocationStruct: Codable {
    let latitude: Double
    let longitude: Double
    
    init(location: CLLocationCoordinate2D) {
        self.latitude = location.latitude
        self.longitude = location.longitude
    }
}

struct SpanStruct: Codable {
    let latitudeDelta: Double
    let longitudeDelta: Double
    
    init(span: MKCoordinateSpan) {
        self.latitudeDelta = span.latitudeDelta
        self.longitudeDelta = span.longitudeDelta
    }
}

struct RegionStruct: Codable {
    let center: LocationStruct
    let span: SpanStruct
    
    init(region: MKCoordinateRegion) {
        self.center = LocationStruct(location: region.center)
        self.span = SpanStruct(span: region.span)
    }
}

extension CLLocationCoordinate2D {
    static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    init(location: LocationStruct) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
}

extension MKCoordinateSpan {
    init(span: SpanStruct) {
        self.init(latitudeDelta: span.latitudeDelta, longitudeDelta: span.longitudeDelta)
    }
}

extension MKCoordinateRegion {
    init(region: RegionStruct) {
        self.init(center: CLLocationCoordinate2D(location: region.center), span: MKCoordinateSpan(span: region.span))
    }
}

//extension CLRegion {
//    static func == (lhs: CLRegion, rhs: CLLocationCoordinate2D) -> Bool {
//        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
//    }
//}
