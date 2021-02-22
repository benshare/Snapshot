//
//  UserPreferences.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/19/21.
//

import Foundation

enum SnapshotSource {
    case camera, library
}

class UserPreferences {
    var defaultSource: SnapshotSource
    
    required init() {
        defaultSource = .camera
    }
}
