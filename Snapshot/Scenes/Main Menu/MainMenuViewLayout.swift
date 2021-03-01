//
//  MainMenuViewLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/28/21.
//

import Foundation
import UIKit

class MainMenuViewViewLayout {
    // MARK: Properties
    
    // UI elements
    private let titleLabel: UILabel
    private let stackView: UIStackView
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(titleLabel: UILabel, stackView: UIStackView) {
        self.titleLabel = titleLabel
        self.stackView = stackView

        doNotAutoResize(views: [titleLabel, stackView])
        setTextToDefaults(labels: [titleLabel])
        setButtonsToDefaults(buttons: [])
        
        titleLabel.text = "SNAPSHOT"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .lightGray
        titleLabel.backgroundColor = .darkGray
        
        stackView.backgroundColor = .lightGray
        
        // Portrait
        portraitSizeMap = [
            titleLabel: (1, 0.2),
            stackView: (1, 0.8),
        ]
        
        portraitSpacingMap = [
            titleLabel: (0.5, 0.1),
            stackView: (0.5, 0.6),
        ]
        
        // Landscape
        landscapeSizeMap = [
            titleLabel: (1, 0.2),
            stackView: (1, 0.8),
        ]
        
        landscapeSpacingMap = [
            titleLabel: (0.5, 0.1),
            stackView: (0.5, 0.6),
        ]
    }
    
    // MARK: Constraints
    
    func configureConstraints(view: UIView)  {
        let margins = view.layoutMarginsGuide
        view.backgroundColor = globalBackgroundColor()
        
        portraitConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: margins.heightAnchor, sizeMap: portraitSizeMap)
        portraitConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: margins.topAnchor, heightAnchor: margins.heightAnchor, spacingMap: portraitSpacingMap, parentView: view)
        
        landscapeConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: margins.heightAnchor, sizeMap: landscapeSizeMap)
        landscapeConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: margins.topAnchor, heightAnchor: margins.heightAnchor, spacingMap: landscapeSpacingMap, parentView: view)
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
