//
//  FullClueView.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/8/21.
//

import Foundation
import UIKit

class FullClueView: UIView {
    // MARK: Variables
    // UI elements
    
    // Formatting
    var layout: FullClueLayout!
    
    // Other
    let clue: Clue
    var nonEmptyHints = [String]()
    let parentController: UIViewController
    var isNew: Bool = false
    var clueNum: Int?
    
    // MARK: Initialization
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(clue: Clue, parentController: UIViewController) {
        self.clue = clue
        self.parentController = parentController
        super.init(frame: CGRect.zero)
    }
    
    func configureView(isNew: Bool = false, clueNum: Int? = nil) {
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 10
        
        self.isNew = isNew
        self.clueNum = clueNum
        
        layout = FullClueLayout(parentController: parentController, clueText: clue.text, clueImage: clue.image, hints: clue.hints.filter({ return !$0.isEmpty }))
        layout.configureConstraints(view: self)
        
        redrawScene()
    }
    
    // MARK: UI
    func redrawScene() {
        let isPortrait = orientationIsPortrait()
        
        if isPortrait {
            layout.setTitleLabel(text: isNew ? "You unlocked\na new clue!" : "Clue #\(clueNum!)")
            layout.setTitleLines(lines: isNew ? 2 : 1)
        } else {
            layout.setTitleLabel(text: isNew ? "You unlocked a new clue!" : "Clue #\(clueNum!)")
            layout.setTitleLines(lines: 1)
        }
        layout!.setOrientation(isPortrait: isPortrait)
    }
}
