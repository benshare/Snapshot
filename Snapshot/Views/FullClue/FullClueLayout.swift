//
//  FullClueLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/9/21.
//

import Foundation
import UIKit

class FullClueLayout {
    // MARK: Properties
    
    // UI elements
    private let titleLabel: UILabel
    private let clueText: UILabel
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(titleLabel: UILabel, clueText: UILabel) {
        self.titleLabel = titleLabel
        self.clueText = clueText

        doNotAutoResize(views: [titleLabel, clueText])
        setLabelsToDefaults(labels: [titleLabel, clueText])
        
        // Portrait
        portraitSizeMap = [
            titleLabel: (0.7, 0.2),
            clueText: (0.8, 0.6),
        ]
        
        portraitSpacingMap = [
            titleLabel: (0.5, 0.2),
            clueText: (0.5, 0.6),
        ]
        
        // Landscape
        landscapeSizeMap = [:
//            titleLabel: (, ),
//            clueText: (, ),
        ]
        
        landscapeSpacingMap = [:
//            titleLabel: (, ),
//            clueText: (, ),
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
