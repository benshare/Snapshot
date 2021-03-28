//
//  EditHuntViewLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/1/21.
//

import Foundation
import UIKit

class EditHuntViewLayout {
    // MARK: Properties
    
    // UI elements
    private let navigationBar: NavigationBarView
    private let clueList: ScrollableStackView
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    var portraitConstraints = [NSLayoutConstraint]()
    var landscapeConstraints = [NSLayoutConstraint]()
    
    init(navigationBar: NavigationBarView, clueList: ScrollableStackView) {
        self.navigationBar = navigationBar
        self.clueList = clueList
        clueList.backgroundColor = .lightGray

        doNotAutoResize(views: [navigationBar, clueList])
        setLabelsToDefaults(labels: [])
        setButtonsToDefaults(buttons: [])
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            clueList: (1, 0.8),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            clueList: (0.5, 0.6),
        ]
        
        // Landscape
        landscapeSizeMap = [
            navigationBar: (1, 0.3),
            clueList: (1, 0.7),
        ]

        landscapeSpacingMap = [
            navigationBar: (0.5, 0.15),
            clueList: (0.5, 0.65),
        ]
        
        for row in clueList.arrangedViews() {
            portraitConstraints.append(contentsOf: getSizeConstraints(widthAnchor: clueList.widthAnchor, heightAnchor: clueList.heightAnchor, sizeMap: [row: (1, 0.18)]))
            landscapeConstraints.append(contentsOf: getSizeConstraints(widthAnchor: clueList.widthAnchor, heightAnchor: clueList.heightAnchor, sizeMap: [row: (1, 0.3)]))
        }
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
