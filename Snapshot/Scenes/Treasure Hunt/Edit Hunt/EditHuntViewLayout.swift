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
    private let preferences: UIView
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(navigationBar: NavigationBarView, clueList: ScrollableStackView, preferences: UIView) {
        self.navigationBar = navigationBar
        self.clueList = clueList
        self.preferences = preferences

        doNotAutoResize(views: [navigationBar, clueList, preferences])
        setLabelsToDefaults(labels: [])
        setButtonsToDefaults(buttons: [])
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            clueList: (1, 0.6),
            preferences: (1, 0.2),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            clueList: (0.5, 0.5),
            preferences: (0.5, 0.9),
        ]
        
        // Landscape
        landscapeSizeMap = [:
//            navigationBar: (1, 0.2),
//            clueList: (1, 0.6),
//            preferences: (1, 0.2),
        ]
//
        landscapeSpacingMap = [:
//            navigationBar: (0.5, 0.1),
//                clueList: (0.5, 0.5),
//                preferences: (0.5, 0.89),
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
        NSLayoutConstraint.activate(portraitConstraints)
//        if isPortrait {
//            NSLayoutConstraint.deactivate(landscapeConstraints)
//            NSLayoutConstraint.activate(portraitConstraints)
//        } else {
//            NSLayoutConstraint.deactivate(portraitConstraints)
//            NSLayoutConstraint.activate(landscapeConstraints)
//        }
    }
    
    // MARK: Other UI
}
