//
//  LoginPageLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 4/4/21.
//

import Foundation
import UIKit

class LoginPageLayout {
    // MARK: Variables
    
    // UI elements
    private var welcomeLabel: UILabel!
    private var usernameField: UITextField!
    private var passwordField: UITextField!
    private var forgotButton: UIButton!
    private var signInButton: UIButton!
    private var newUserButton: UIButton!
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    // MARK: Initialization
    init(welcomeLabel: UILabel, usernameField: UITextField, passwordField: UITextField, forgotButton: UIButton, signInButton: UIButton, newUserButton: UIButton) {
        self.welcomeLabel = welcomeLabel
        self.usernameField = usernameField
        self.passwordField = passwordField
        self.forgotButton = forgotButton
        self.signInButton = signInButton
        self.newUserButton = newUserButton
        
        doNotAutoResize(views: [welcomeLabel, usernameField, passwordField, forgotButton, signInButton, newUserButton])
        setLabelsToDefaults(labels: [welcomeLabel])
        setButtonsToDefaults(buttons: [forgotButton])
        
        // Portrait
        portraitSizeMap = [
            welcomeLabel: (1, 0.2),
            usernameField: (0.8, 0.07),
            passwordField: (0.8, 0.07),
            forgotButton: (0.3, 0.05),
            signInButton: (0.8, 0.07),
            newUserButton: (0.8, 0.07),
        ]
        
        portraitSpacingMap = [
            welcomeLabel: (0.5, 0.1),
            usernameField: (0.5, 0.4),
            passwordField: (0.5, 0.55),
            forgotButton: (0.75, 0.62),
            signInButton: (0.5, 0.75),
            newUserButton: (0.5, 0.9),
        ]
        
        // Landscape
        landscapeSizeMap = [
            welcomeLabel: (1, 0.2),
            usernameField: (0.4, 0.12),
            passwordField: (0.4, 0.12),
            forgotButton: (0.15, 0.05),
            signInButton: (0.4, 0.12),
            newUserButton: (0.4, 0.12),
        ]
        
        landscapeSpacingMap = [
            welcomeLabel: (0.5, 0.1),
            usernameField: (0.25, 0.45),
            passwordField: (0.25, 0.75),
            forgotButton: (0.375, 0.87),
            signInButton: (0.75, 0.45),
            newUserButton: (0.75, 0.75),
        ]
    }
    
//    func setUIDefaults() {
//        doNotAutoResize(views: [titleLabel, welcomeLabel, usernameLabel, usernameField, passwordLabel, passwordField, showPasswordButton,  rememberLabel, rememberSwitch, invalidLabel, signInButton, guestButton, newUserButton])
//        setLabelsToDefaults(labels: [titleLabel, welcomeLabel, usernameLabel, passwordLabel, rememberLabel, invalidLabel])
//        setButtonsToDefaults(buttons: [newUserButton, signInButton, guestButton])
//        setButtonsToDefaults(buttons: [showPasswordButton], withInsets: 10)
//
//        titleLabel.text = "Snapshot"
//        welcomeLabel.numberOfLines = 0
//
//        usernameLabel.text = "Username:"
//        usernameField.layer.borderColor = globalTextColor().cgColor
//        passwordField.layer.borderColor = globalTextColor().cgColor
//        usernameField.text = ""
//
//        passwordLabel.text = "Password:"
//        passwordField.text = ""
//
//        invalidLabel.text = ""
//        invalidLabel.font = .italicSystemFont(ofSize: 30)
//        invalidLabel.isHidden = true
//        rememberLabel.text = "Remember me"
//        signInButton.isEnabled = false
//        signInButton.setTitle("Sign In", for: .normal)
//
//        showPasswordButton.setTitle("Show", for: .normal)
//        showPasswordButton.setTitleColor(.gray, for: .normal)
//        showPasswordButton.layer.cornerRadius = 5
//        showPasswordButton.layer.borderColor = globalTextColor().cgColor
//        showPasswordButton.layer.borderWidth = 1
//
//        guestButton.setTitle("Continue without creating account", for: .normal)
//        newUserButton.setTitle("New user? Create an account!", for: .normal)
//    }
    
    func getSignInRow(rememberLabel: UILabel, rememberSwitch: UISwitch, signInButton: UIButton) -> UIView {
        let signInRow = UIView()
        doNotAutoResize(view: signInRow)
        rememberLabel.superview!.addSubview(signInRow)
        signInRow.addSubview(rememberLabel)
        signInRow.addSubview(rememberSwitch)
        signInRow.addSubview(signInButton)
        
        let sizeMap: [UIView: (CGFloat, CGFloat)] = [
            rememberLabel: (0.4, 0.3),
            rememberSwitch: (0.2, 0.5),
            signInButton: (0.4, 0.8),
        ]
        
        let spacingMap: [UIView: (CGFloat, CGFloat)] = [
            rememberLabel: (0.2, 0.15),
            rememberSwitch: (0.2, 0.75),
            signInButton: (0.8, 0.5),
        ]
        
        NSLayoutConstraint.activate(
            getSizeConstraints(widthAnchor: signInRow.widthAnchor, heightAnchor: signInRow.heightAnchor, sizeMap: sizeMap) +
                getSpacingConstraints(leftAnchor: signInRow.leftAnchor, widthAnchor: signInRow.widthAnchor, topAnchor: signInRow.topAnchor, heightAnchor: signInRow.heightAnchor, spacingMap: spacingMap, parentView: signInRow)
        )
        
        return signInRow
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
