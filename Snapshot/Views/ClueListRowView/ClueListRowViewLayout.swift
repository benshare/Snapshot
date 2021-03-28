//
//  ClueListRowViewLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/1/21.
//

import Foundation
import UIKit

class ClueListRowViewLayout {
    // MARK: Properties
    
    // UI elements
    private let indexLabel: UILabel
    private let divider: UIView
    private let clueLabel: UILabel
    private let upArrow: UIButton
    private let downArrow: UIButton
    private let deleteButton: UIButton
    
    // Constraint maps
    private var sizeMap: [UIView: (CGFloat, CGFloat)]!
    private var spacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var constraints = [NSLayoutConstraint]()
    
    init(indexLabel: UILabel, divider: UIView, clueLabel: UILabel, upArrow: UIButton, downArrow: UIButton, deleteButton: UIButton, rowType: RowType) {
        self.indexLabel = indexLabel
        self.divider = divider
        self.clueLabel = clueLabel
        self.upArrow = upArrow
        self.downArrow = downArrow
        self.deleteButton = deleteButton

        doNotAutoResize(views: [indexLabel, divider, clueLabel, upArrow, downArrow, deleteButton])
        setLabelsToDefaults(labels: [indexLabel, clueLabel])
        setButtonsToDefaults(buttons: [upArrow, downArrow, deleteButton])
        indexLabel.font = UIFont.systemFont(ofSize: 30)
        clueLabel.font = UIFont.italicSystemFont(ofSize: 30)
        
        switch rowType {
        case .start:
            divider.isHidden = true
            clueLabel.isHidden = true
            upArrow.isHidden = true
            downArrow.isHidden = true
            deleteButton.isHidden = true
            sizeMap = [
                indexLabel: (0.6, 1),
            ]
            
            spacingMap = [
                indexLabel: (0.5, 0.5),
            ]
            
        case .clue:
            sizeMap = [
                indexLabel: (0.1, 1),
                divider: (0.003, 0.7),
                clueLabel: (0.5, 1),
                upArrow: (0, 0.5),
                downArrow: (0, 0.5),
                deleteButton: (0, 0.5),
            ]
            
            spacingMap = [
                indexLabel: (0.075, 0.5),
                divider: (0.15, 0.5),
                clueLabel: (0.475, 0.5),
                upArrow: (0.8, 0.25),
                downArrow: (0.8, 0.75),
                deleteButton: (0.925, 0.5),
            ]
        }
    }
    
    // MARK: Constraints
    func configureConstraints(view: UIView)  {
        view.backgroundColor = globalBackgroundColor()
        
        constraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: sizeMap)
        constraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: spacingMap, parentView: view)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: Other UI
}
