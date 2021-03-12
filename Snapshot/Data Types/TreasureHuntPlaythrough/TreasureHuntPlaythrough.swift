//
//  TreasureHuntPlaythrough.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/8/21.
//

import Foundation
import MapKit

class TreasureHuntPlaythrough {
    let hunt: TreasureHunt
    var unlockedClues: [Clue]
    var nextClueNum: Int
    
    init(hunt: TreasureHunt) {
        self.hunt = hunt
        self.unlockedClues = [Clue]()
        self.nextClueNum = 0
    }
    
    func unlockClue() -> Clue {
        print("Current target location is \(nextLocation())")
        let clue = hunt.clues[nextClueNum]
        unlockedClues.append(clue)
        nextClueNum += 1
        return clue
    }
    
    func nextLocation() -> CLLocationCoordinate2D? {
        if hunt.clues.count > nextClueNum {
            return hunt.clues[nextClueNum].location
        }
        return nil
    }
}
