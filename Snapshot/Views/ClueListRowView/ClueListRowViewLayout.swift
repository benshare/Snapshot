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
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(indexLabel: UILabel, divider: UIView, clueLabel: UILabel) {
        self.indexLabel = indexLabel
        self.divider = divider
        self.clueLabel = clueLabel

        doNotAutoResize(views: [indexLabel, divider, clueLabel])
        setLabelsToDefaults(labels: [indexLabel, clueLabel])
        indexLabel.font = UIFont.systemFont(ofSize: 30)
        clueLabel.font = UIFont.italicSystemFont(ofSize: 30)
        
        // Portrait
        portraitSizeMap = [
            indexLabel: (0.15, 1),
            divider: (0.003, 0.7),
            clueLabel: (0.6, 1),
        ]
        
        portraitSpacingMap = [
            indexLabel: (0.1, 0.5),
            divider: (0.2, 0.5),
            clueLabel: (0.6, 0.5),
        ]
        
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
