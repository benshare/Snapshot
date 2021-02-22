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
    var imageMap: [String: UIImage]

    // MARK: Initialization
    init(collection: SnapshotCollection = SnapshotCollection()) {
        self.collection = collection
        imageMap = [:]
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        for snapshot in collection.collection {
            addSnapshotToMap(snapshot: snapshot)
            imageMap[snapshot.title ?? snapshot.time.description] = snapshot.image
        }
    }
    
    required init?(coder: NSCoder) {
        self.collection = SnapshotCollection()
        self.imageMap = [:]
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
        if snapshot.image != nil {
            imageMap[title] = snapshot.image
        }
        self.addAnnotation(annotation)
    }
}
