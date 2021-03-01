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
    "Settings",
]

let SCENE_ICONS: [String: String] = [
    "Explore": "MapIcon",
    "Treasure Hunt": "TreasureIcon",
    "Settings": "SettingsIcon",
]

let SCENE_SEGUES: [String: String] = [
    "Explore": "exploreSegue",
    "Treasure Hunt": "treasureSegue",
    "Settings": "settingsSegue",
]
