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
    var currentClueNum: Int
    var currentClueWaitsToShow: Bool
    
    init(hunt: TreasureHunt) {
        self.hunt = hunt
        self.unlockedClues = [hunt.clues[0]]
        self.currentClueNum = 0
        self.currentClueWaitsToShow = hunt.clues[0].showImageAfter
    }
    
    func getCurrentClue() -> Clue {
        return hunt.clues[currentClueNum]
    }
    
    func unlockNextClue() -> Bool {
        currentClueNum += 1
        if currentClueNum < hunt.clues.count {
            let clue = hunt.clues[currentClueNum]
            unlockedClues.append(clue)
            currentClueWaitsToShow = clue.showImageAfter
            return true
        }
        return false
    }
}
