//
//  MemoryMapView.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/20/21.
//

import Foundation
import UIKit
import MapKit

class MemoryMapView: MKMapView {
    // MARK: Variables
    let collection: SnapshotCollection
    var snapshotMap: [String: Snapshot]

    // MARK: Initialization
    init(collection: SnapshotCollection = SnapshotCollection()) {
        self.collection = collection
        snapshotMap = [:]
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        for snapshot in collection.collection.values {
            addSnapshotToMap(snapshot: snapshot)
            snapshotMap[snapshot.title ?? snapshot.time.description] = snapshot
        }
    }
    
    required init?(coder: NSCoder) {
        self.collection = SnapshotCollection()
        self.snapshotMap = [:]
        super.init(coder: coder)
    }

    // MARK: Collection
    func addSnapshot(snapshot: Snapshot) {
        collection.addSnapshot(snapshot: snapshot)
        addSnapshotToMap(snapshot: snapshot)
    }

    private func addSnapshotToMap(snapshot: Snapshot) {
        let annotation = MKPointAnnotation()
        let title = snapshot.title ?? snapshot.time.description
        annotation.title = title
        annotation.coordinate = snapshot.location
        snapshotMap[title] = snapshot
        self.addAnnotation(annotation)
    }
    
    // MARK: Formatting
//    func formatAnnotation(annotation: MKAnnotation) {
//        self.view(
//        let layer = (self.view(for: annotation)?.layer)!
//        layer.cornerRadius = 20
//        layer.borderWidth = 10
//        layer.borderColor = UIColor.white.cgColor
//    }
}
