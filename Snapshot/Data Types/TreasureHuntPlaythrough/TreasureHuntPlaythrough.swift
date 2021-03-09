//
//  TreasureHuntPlaythrough.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/8/21.
//

import Foundation

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
        let clue = hunt.clues[nextClueNum]
        unlockedClues.append(clue)
        nextClueNum += 1
        return clue
    }
}
