//
//  ClueListRowView.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/1/21.
//

import Foundation
import UIKit

class ClueListRowView: UIView {
    // MARK: Variables
    // Elements
    private let indexLabel = UILabel()
    private let divider = UIView()
    private let clueLabel = UILabel()
    
    // Layout
    private var layout: ClueListRowViewLayout!
    
    // MARK: Initialization
    init(index: Int, text: String) {
        super.init(frame: CGRect())
        self.addSubview(indexLabel)
        self.addSubview(divider)
        self.addSubview(clueLabel)
        layout = ClueListRowViewLayout(indexLabel: indexLabel, divider: divider, clueLabel: clueLabel)
        layout.configureConstraints(view: self)
        redrawScene()

        indexLabel.text = String(index)

        divider.backgroundColor = .black

        clueLabel.text = textToDisplay(text: text)
        
//        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
    }
    
    // MARK: Content
    func updateIndex(index: Int) {
        indexLabel.text = String(index)
    }
    
    func updateClue(text: String) {
        clueLabel.text = textToDisplay(text: text)
    }
    
    func textToDisplay(text: String) -> String {
        if text.isEmpty {
            return "No clue text"
        }
        let prefix = text.prefix(25)
        if let returnIndex = prefix.firstIndex(of: "\n") {
            return String(prefix.prefix(upTo: returnIndex)) + "..."
        }
        if let returnIndex = prefix.lastIndex(of: " ") {
            return String(prefix.prefix(upTo: returnIndex)) + "..."
        }
        return String(prefix) + "..."
    }
}
