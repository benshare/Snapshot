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
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
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
            portraitSizeMap = [
                indexLabel: (0.6, 1),
            ]
            
            portraitSpacingMap = [
                indexLabel: (0.5, 0.5),
            ]
            
        case .clue:
            portraitSizeMap = [
                indexLabel: (0.1, 1),
                divider: (0.003, 0.7),
                clueLabel: (0.5, 1),
                upArrow: (0, 0.5),
                downArrow: (0, 0.5),
                deleteButton: (0.1, 0),
            ]
            
            portraitSpacingMap = [
                indexLabel: (0.075, 0.5),
                divider: (0.15, 0.5),
                clueLabel: (0.475, 0.5),
                upArrow: (0.8, 0.25),
                downArrow: (0.8, 0.75),
                deleteButton: (0.925, 0.5),
            ]
        }
        
        // Portrait
//        portraitSizeMap = [
//            indexLabel: (0.15, 1),
//            divider: (0.003, 0.7),
//            clueLabel: (0.6, 1),
//        ]
//
//        portraitSpacingMap = [
//            indexLabel: (0.1, 0.5),
//            divider: (0.2, 0.5),
//            clueLabel: (0.6, 0.5),
//        ]
        
        // Landscape
        landscapeSizeMap = [
            indexLabel: (0.15, 1),
            divider: (0.003, 0.8),
            clueLabel: (0.7, 1),
        ]

        landscapeSpacingMap = [
            indexLabel: (0.1, 0.5),
            divider: (0.2, 0.5),
            clueLabel: (0.6, 0.5),
        ]
    }
    
    // MARK: Constraints
    func configureConstraints(view: UIView)  {
        view.backgroundColor = globalBackgroundColor()
        
        portraitConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: portraitSizeMap)
        portraitConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: portraitSpacingMap, parentView: view)
        
        landscapeConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: landscapeSizeMap)
        landscapeConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: landscapeSpacingMap, parentView: view)
    }
    
    func activateConstraints(isPortrait: Bool) {
        if isPortrait {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
        } else {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        }
    }
    
    // MARK: Other UI
}
