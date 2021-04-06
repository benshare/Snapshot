//
//  Globals.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/21/21.
//

import Foundation
import UIKit


// MARK: Scenes
let SCENES: [String] = [
    "Explore",
    "Treasure Hunt",
    "Account",
]

let SCENE_ICONS: [String: String] = [
    "Explore": "MapIcon",
    "Treasure Hunt": "TreasureIcon",
    "Account": "UserIconOutline",
]

let SCENE_SEGUES: [String: String] = [
    "Explore": "exploreSegue",
    "Treasure Hunt": "treasureSegue",
    "Account": "accountSegue",
]
