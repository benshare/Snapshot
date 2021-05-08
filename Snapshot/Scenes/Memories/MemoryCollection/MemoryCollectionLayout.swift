//
//  MemoryCollectionLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/22/21.
//

import Foundation
import UIKit

class MemoryCollectionLayout {
    // MARK: Properties
    
    // UI elements
    private let navigationBar: NavigationBarView
    private let memoryList: ScrollableStackView
    private let huntButton: UIButton
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    // Other
    private var circularViews = [UIView]()
    
    // MARK: Initialization
    init(navigationBar: NavigationBarView, memoryList: ScrollableStackView, huntButton: UIButton) {
        self.navigationBar = navigationBar
        self.memoryList = memoryList
        self.huntButton = huntButton

        doNotAutoResize(views: [navigationBar, memoryList, huntButton])
        setLabelsToDefaults(labels: [])
        setButtonsToDefaults(buttons: [huntButton], withImageInsets: 10)
        circularViews.append(contentsOf: [huntButton])
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            memoryList: (1, 0.8),
            huntButton: (0.15, 0),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            memoryList: (0.5, 0.6),
            huntButton: (0.5, 0.92),
        ]
        
        // Landscape
        landscapeSizeMap = [
            navigationBar: (1, 0.3),
            memoryList: (1, 0.75),
            huntButton: (0.08, 0),
        ]
        
        landscapeSpacingMap = [
            navigationBar: (0.5, 0.1),
            memoryList: (0.5, 0.625),
            huntButton: (0.5, 0.9),
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
    func updateCircleSizes() {
        makeViewsCircular(views: circularViews)
    }
    
    func showDeleteButtons() {
        for row in memoryList.arrangedViews() as! [CollectionRowView] {
            row.showDeleteButtons()
        }
    }
    
    func hideDeleteButtons() {
        for row in memoryList.arrangedViews() as! [CollectionRowView] {
            row.hideDeleteButtons()
        }
    }
}
