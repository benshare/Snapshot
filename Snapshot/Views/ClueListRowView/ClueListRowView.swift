//
//  ClueListRowView.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/1/21.
//

import Foundation
import UIKit

public enum RowType {
    case start, clue
}

class ClueListRowView: UIView {
    // MARK: Variables
    // Elements
    private let indexLabel = UILabel()
    private let divider = UIView()
    private let clueLabel = UILabel()
    let upArrow = UIButton()
    let downArrow = UIButton()
    let deleteButton = UIButton()
    
    // Layout
    private var layout: ClueListRowViewLayout!
    
    // Data
    var index: Int!
    
    // MARK: Initialization
    init(index: Int, text: String) {
        super.init(frame: CGRect())
        self.addSubview(indexLabel)
        self.addSubview(divider)
        self.addSubview(clueLabel)
        self.addSubview(upArrow)
        self.addSubview(downArrow)
        self.addSubview(deleteButton)
        layout = ClueListRowViewLayout(indexLabel: indexLabel, divider: divider, clueLabel: clueLabel, upArrow: upArrow, downArrow: downArrow, deleteButton: deleteButton, rowType: index == 0 ? .start : .clue)
        layout.configureConstraints(view: self)
        redrawScene()

        self.index = index
        updateIndexLabel()

        divider.backgroundColor = .black

        clueLabel.text = textToDisplay(text: text)
        
        upArrow.setBackgroundImage(UIImage(named: "ArrowUpIcon"), for: .normal)
        downArrow.setBackgroundImage(UIImage(named: "ArrowDownIcon"), for: .normal)
        deleteButton.setBackgroundImage(UIImage(named: "TrashIcon"), for: .normal)
        
        redrawScene()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    func redrawScene() {
        layout.activateConstraints()
    }
    
    // MARK: Content
    func updateIndexLabel() {
        switch index {
        case 0:
            indexLabel.text = "Starting location"
        default:
            indexLabel.text = String(index)
        }
    }
    
    func updateClue(text: String) {
        clueLabel.text = textToDisplay(text: text)
    }
    
    func textToDisplay(text: String) -> String {
        if text.isEmpty {
            return "No clue text"
        }
        if text.count < 26 {
            if let returnIndex = text.firstIndex(of: "\n") {
                return String(text.prefix(upTo: returnIndex)) + "..."
            }
            return text
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
    
    func disableUpArrow() {
        upArrow.isEnabled = false
        upArrow.tintColor = .gray
    }
    
    func enableUpArrow() {
        upArrow.isEnabled = true
        upArrow.tintColor = .none
    }
    
    func disableDownArrow() {
        downArrow.isEnabled = false
        downArrow.tintColor = .gray
    }
    
    func enableDownArrow() {
        downArrow.isEnabled = true
        downArrow.tintColor = .none
    }
}
