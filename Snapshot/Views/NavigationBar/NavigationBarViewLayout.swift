//
//  NavigationBarViewLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/1/21.
//

import Foundation
import UIKit

class NavigationBarViewViewLayout {
    // MARK: Properties
    
    // UI elements
    private let leftItem: UIButton
    private let title: UILabel
    private let editableTitle: UITextField
    private let rightItem: UIButton
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(leftItem: UIButton, title: UILabel, editableTitle: UITextField, rightItem: UIButton) {
        self.leftItem = leftItem
        self.title = title
        self.editableTitle = editableTitle
        self.rightItem = rightItem

        doNotAutoResize(views: [leftItem, title, editableTitle, rightItem])
        setTextToDefaults(labels: [title])
        setButtonsToDefaults(buttons: [leftItem, rightItem])
        
        editableTitle.font = UIFont.systemFont(ofSize: 30)
        editableTitle.adjustsFontSizeToFitWidth = true
        editableTitle.autocapitalizationType = .sentences
        editableTitle.autocorrectionType = .yes
        editableTitle.textAlignment = .center
        
        // Portrait
        portraitSizeMap = [
            leftItem: (0.12, 0.5),
            title: (0.6, 0.5),
            editableTitle: (0.6, 0.5),
            rightItem: (0.12, 0.5),
        ]
        
        portraitSpacingMap = [
            leftItem: (0.1, 0.25),
            title: (0.5, 0.65),
            editableTitle: (0.5, 0.65),
            rightItem: (0.9, 0.25),
        ]
        
        // Landscape
        landscapeSizeMap = [
            leftItem: (0.12, 0.5),
            title: (0.6, 0.5),
            editableTitle: (0.6, 0.5),
            rightItem: (0.2, 0.5),
        ]
        
        landscapeSpacingMap = [
            leftItem: (0.1, 0.5),
            title: (0.5, 0.5),
            editableTitle: (0.5, 0.5),
            rightItem: (0.9, 0.5),
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
