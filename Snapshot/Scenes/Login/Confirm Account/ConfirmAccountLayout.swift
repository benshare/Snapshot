//
//  ConfirmAccountLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 5/1/21.
//

import Foundation
import UIKit

class ConfirmAccountLayout: UILayout {
    // MARK: Properties
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // MARK: Initialization
    init(navigationBar: NavigationBarView, codeField: SegmentedTextField, resendButton: UIButton, confirmButton: UIButton) {

        doNotAutoResize(views: [navigationBar, codeField, resendButton, confirmButton])
        setLabelsToDefaults(labels: [])
        setButtonsToDefaults(buttons: [])
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            codeField: (0.8, 0.07),
            resendButton: (0.3, 0.05),
            confirmButton: (0.8, 0.07),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            codeField: (0.5, 0.5),
            resendButton: (0.25, 0.6),
            confirmButton: (0.5, 0.8),
        ]
        
        // Landscape
        landscapeSizeMap = [
            navigationBar: (1, 0.3),
            codeField: (0.6, 0.1),
            resendButton: (0.2, 0.05),
            confirmButton: (0.6, 0.1),
        ]
        
        landscapeSpacingMap = [
            navigationBar: (0.5, 0.1),
            codeField: (0.5, 0.5),
            resendButton: (0.3, 0.6),
            confirmButton: (0.5, 0.8),
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
