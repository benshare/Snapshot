//
//  NewAccountLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 5/1/21.
//

import Foundation
import UIKit

class NewAccountLayout: UILayout {
    // MARK: Properties
    
    // UI elements
    private let navigationBar: NavigationBarView
    private let usernameField: UITextField
    private let passwordField: UITextField
    private let phoneField: UITextField
    private let signUpButton: UIButton
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // MARK: Initialization
    init(navigationBar: NavigationBarView, usernameField: UITextField, passwordField: UITextField, phoneField: UITextField, signUpButton: UIButton) {
        self.navigationBar = navigationBar
        self.usernameField = usernameField
        self.passwordField = passwordField
        self.phoneField = phoneField
        self.signUpButton = signUpButton

        doNotAutoResize(views: [navigationBar, usernameField, passwordField, phoneField, signUpButton])
        setLabelsToDefaults(labels: [])
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            usernameField: (0.8, 0.07),
            passwordField: (0.8, 0.07),
            phoneField: (0.8, 0.07),
            signUpButton: (0.8, 0.07),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            usernameField: (0.5, 0.35),
            passwordField: (0.5, 0.5),
            phoneField: (0.5, 0.65),
            signUpButton: (0.5, 0.85),
        ]
        
        // Landscape
        landscapeSizeMap = [
            navigationBar: (1, 0.3),
            usernameField: (0.6, 0.1),
            passwordField: (0.6, 0.1),
            phoneField: (0.6, 0.1),
            signUpButton: (0.6, 0.1),
        ]
        
        landscapeSpacingMap = [
            navigationBar: (0.5, 0.1),
            usernameField: (0.5, 0.35),
            passwordField: (0.5, 0.5),
            phoneField: (0.5, 0.65),
            signUpButton: (0.5, 0.85),
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
