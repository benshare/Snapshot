//
//  AccountPageLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 4/4/21.
//

import Foundation
import UIKit

class AccountPageLayout {
    // MARK: Properties
    
    // UI elements
    private let navigationBar: NavigationBarView
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    // MARK: Initialization
    init(navigationBar: NavigationBarView) {
        self.navigationBar = navigationBar

        doNotAutoResize(views: [navigationBar])
        setLabelsToDefaults(labels: [])
        setButtonsToDefaults(buttons: [])
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
        ]
        
        // Landscape
        landscapeSizeMap = [
            navigationBar: (1, 0.3),
        ]
        
        landscapeSpacingMap = [
            navigationBar: (0.5, 0.15),
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
