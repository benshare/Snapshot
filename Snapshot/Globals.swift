//
//  Globals.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/21/21.
//

import Foundation
import UIKit

enum SceneCode: String {
    case main, map, hunts, account
}

// MARK: Scenes
let SCENE_CODES: [SceneCode] = [
    .map, .hunts, .account
]

let SCENE_ICONS: [SceneCode: String] = [
    .map: "MapIcon",
    .hunts: "TreasureIcon",
    .account: "SettingsIcon",
]

let SCENE_SEGUES: [SceneCode: String] = [
    .map: "exploreSegue",
    .hunts: "huntSegue",
    .account: "accountSegue",
]

let SCENE_COLORS: [SceneCode: UIColor] = [
    .main: UIColor(hex: "218484")!,
    .map: UIColor(hex: "76B089")!,
    .hunts: UIColor(hex: "bfa96d")!,
    .account: UIColor(hex: "7E83A4")!,
]
