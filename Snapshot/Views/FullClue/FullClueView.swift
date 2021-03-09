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
    let titleLabel: UILabel
    let clueText: UILabel
    
    // Formatting
    var layout: FullClueLayout!
    
    // MARK: Initialization
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String, isNew: Bool = false, clueNum: Int?) {
        titleLabel = UILabel()
        titleLabel.text = isNew ? "You unlocked\na new clue!" : "Clue #\(clueNum!)"
        titleLabel.numberOfLines = 2
        clueText = UILabel()
        clueText.text = text
        super.init(frame: CGRect.zero)
    }
    
    func configureView() {
        addSubview(titleLabel)
        addSubview(clueText)
        layout = FullClueLayout(titleLabel: titleLabel, clueText: clueText)
        layout.configureConstraints(view: self)
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 10
        redrawScene()
    }
    
    // MARK: UI
    func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout!.activateConstraints(isPortrait: isPortrait)
    }
}
