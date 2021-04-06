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
    private var titleLabel: UILabel!
    private var welcomeLabel: UILabel!
    private var usernameLabel: UILabel!
    private var usernameField: UITextField!
    private var passwordLabel: UILabel!
    private var passwordField: UITextField!
    private var showPasswordButton: UIButton!
    private var rememberLabel: UILabel!
    private var rememberSwitch: UISwitch!
    private var invalidLabel: UILabel!
    private var signInButton: UIButton!
    private var guestButton: UIButton!
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
    init(titleLabel: UILabel, welcomeLabel: UILabel, usernameLabel: UILabel, usernameField: UITextField, passwordLabel: UILabel, passwordField: UITextField, showPasswordButton: UIButton,  rememberLabel: UILabel, rememberSwitch: UISwitch, invalidLabel: UILabel, signInButton: UIButton, guestButton: UIButton, newUserButton: UIButton) {
        self.titleLabel = titleLabel
        self.welcomeLabel = welcomeLabel
        self.usernameLabel = usernameLabel
        self.usernameField = usernameField
        self.passwordLabel = passwordLabel
        self.passwordField = passwordField
        self.showPasswordButton = showPasswordButton
        self.invalidLabel = invalidLabel
        self.rememberLabel = rememberLabel
        self.rememberSwitch = rememberSwitch
        self.signInButton = signInButton
        self.newUserButton = newUserButton
        self.guestButton = guestButton
        
        let signInRow = getSignInRow(rememberLabel: rememberLabel, rememberSwitch: rememberSwitch, signInButton: signInButton)
        
        // Portrait
        portraitSizeMap = [
            titleLabel: (0.8, 0.15),
            welcomeLabel: (0.7, 0.1),
            usernameLabel: (0.2, 0.06),
            usernameField: (0.7, 0.05),
            passwordLabel: (0.2, 0.06),
            passwordField: (0.7, 0.05),
            showPasswordButton: (0.15, 0.05),
            signInRow: (0.5, 0.1),
            invalidLabel: (0.6, 0.1),
            guestButton: (0.6, 0.1),
            newUserButton: (0.5, 0.1),
        ]
        
        portraitSpacingMap = [
            titleLabel: (0.5, 0.08),
            welcomeLabel: (0.5, 0.22),
            usernameLabel: (0.1, 0.35),
            usernameField: (0.6, 0.35),
            passwordLabel: (0.1, 0.5),
            passwordField: (0.6, 0.5),
            showPasswordButton: (0.875, 0.575),
            signInRow: (0.5, 0.69),
            invalidLabel: (0.5, 0.58),
            guestButton: (0.5, 0.8),
            newUserButton: (0.5, 0.9),
        ]
        
        // Landscape
        landscapeSizeMap = [
            titleLabel: (0.6, 0.19),
            welcomeLabel: (0.4, 0.1),
            usernameLabel: (0.15, 0.1),
            usernameField: (0.4, 0.08),
            passwordLabel: (0.15, 0.1),
            passwordField: (0.4, 0.08),
            showPasswordButton: (0.08, 0.07),
            signInRow: (0.3, 0.12),
            invalidLabel: (0.35, 0.1),
            newUserButton: (0.3, 0.1),
            guestButton: (0.3, 0.1),
        ]
        
        landscapeSpacingMap = [
            titleLabel: (0.5, 0.1),
            welcomeLabel: (0.5, 0.25),
            usernameLabel: (0.1, 0.45),
            usernameField: (0.4, 0.45),
            passwordLabel: (0.1, 0.65),
            passwordField: (0.4, 0.65),
            signInRow: (0.85, 0.45),
            newUserButton: (0.85, 0.65),
            showPasswordButton: (0.56, 0.75),
            invalidLabel: (0.5, 0.9),
            guestButton: (0.85, 0.85),
        ]
        
        // Do other UI setup
        setUIDefaults()
    }
    
    func setUIDefaults() {
        doNotAutoResize(views: [titleLabel, welcomeLabel, usernameLabel, usernameField, passwordLabel, passwordField, showPasswordButton,  rememberLabel, rememberSwitch, invalidLabel, signInButton, guestButton, newUserButton])
        setLabelsToDefaults(labels: [titleLabel, welcomeLabel, usernameLabel, passwordLabel, rememberLabel, invalidLabel])
        setButtonsToDefaults(buttons: [newUserButton, signInButton, guestButton])
        setButtonsToDefaults(buttons: [showPasswordButton], withInsets: 10)
        
        titleLabel.text = "Snapshot"
        welcomeLabel.numberOfLines = 0
        
        usernameLabel.text = "Username:"
        usernameField.layer.borderColor = globalTextColor().cgColor
        passwordField.layer.borderColor = globalTextColor().cgColor
        usernameField.text = ""
        
        passwordLabel.text = "Password:"
        passwordField.text = ""
        
        invalidLabel.text = ""
        invalidLabel.font = .italicSystemFont(ofSize: 30)
        invalidLabel.isHidden = true
        rememberLabel.text = "Remember me"
        signInButton.isEnabled = false
        signInButton.setTitle("Sign In", for: .normal)
        
        showPasswordButton.setTitle("Show", for: .normal)
        showPasswordButton.setTitleColor(.gray, for: .normal)
        showPasswordButton.layer.cornerRadius = 5
        showPasswordButton.layer.borderColor = globalTextColor().cgColor
        showPasswordButton.layer.borderWidth = 1
        
        guestButton.setTitle("Continue without creating account", for: .normal)
        newUserButton.setTitle("New user? Create an account!", for: .normal)
    }
    
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
        let margins = view.layoutMarginsGuide
        view.backgroundColor = globalBackgroundColor()
        
        portraitConstraints += getSizeConstraints(widthAnchor: margins.widthAnchor, heightAnchor: margins.heightAnchor, sizeMap: portraitSizeMap)
        portraitConstraints += getSpacingConstraints(leftAnchor: margins.leftAnchor, widthAnchor: margins.widthAnchor, topAnchor: margins.topAnchor, heightAnchor: margins.heightAnchor, spacingMap: portraitSpacingMap, parentView: view)
        
        landscapeConstraints += getSizeConstraints(widthAnchor: margins.widthAnchor, heightAnchor: margins.heightAnchor, sizeMap: landscapeSizeMap)
        landscapeConstraints += getSpacingConstraints(leftAnchor: margins.leftAnchor, widthAnchor: margins.widthAnchor, topAnchor: margins.topAnchor, heightAnchor: margins.heightAnchor, spacingMap: landscapeSpacingMap, parentView: view)
    }
    
    func activateConstraints(isPortrait: Bool) {
        if signInButton.titleLabel?.text == "Sign In" {
            welcomeLabel.text = "Welcome!\nPlease sign in to continue."
        } else {
            welcomeLabel.text = "Welcome!\nCreate an account below."
        }
        if isPortrait {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
//            if signInButton.titleLabel?.text == "Sign In" {
//                welcomeLabel.text = "Welcome!\nPlease sign in to continue."
//            } else {
//                welcomeLabel.text = "Welcome!\nCreate an account below."
//            }
        } else {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
//            if signInButton.titleLabel?.text == "Sign In" {
//                welcomeLabel.text = "Welcome! Please sign in to continue."
//            } else {
//                welcomeLabel.text = "Welcome! Create an account below."
//            }
        }
    }
    
    // MARK: Other UI
    func switchToReturningUser() {
        invalidLabel.isHidden = true
        welcomeLabel.text = "Welcome!\nPlease sign in to continue."
        signInButton.setTitle("Sign In", for: .normal)
        newUserButton.setTitle("New user? Create an account!", for: .normal)
    }
    
    func switchToNewUser() {
        invalidLabel.isHidden = true
        welcomeLabel.text = "Welcome!\nCreate an account below"
        signInButton.setTitle("Create", for: .normal)
        newUserButton.setTitle("Returning user? Sign in!", for: .normal)
    }
}
