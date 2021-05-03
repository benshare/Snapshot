//
//  LoginPageController.swift
//  Snapshot
//
//  Created by Benjamin Share on 4/4/21.
//

import Foundation
import UIKit

class LoginPageController: UIViewController, UITextFieldDelegate {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var newUserButton: UIButton!
    
    // Values to track
    private var usernameIsValid: Bool = false
    private var passwordisValid: Bool = false
    
    // Formatting
    private var layout: LoginPageLayout!
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout = LoginPageLayout(welcomeLabel: welcomeLabel, usernameField: usernameField, passwordField: passwordField, forgotButton: forgotButton, signInButton: signInButton, newUserButton: newUserButton)
        layout.configureConstraints(view: view)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        welcomeLabel.text = "Welcome"
        welcomeLabel.backgroundColor = .systemGreen
        welcomeLabel.textColor = .white
        
        usernameField.delegate = self as UITextFieldDelegate
        usernameField.addTarget(self, action: #selector(usernameFieldDidChange), for: .editingChanged)
        usernameField.placeholder = "Username"
        
        passwordField.delegate = self as UITextFieldDelegate
        passwordField.addTarget(self, action: #selector(passwordFieldDidChange), for: .editingChanged)
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Password"
        passwordField.addVisibilityIcon()
        
        forgotButton.setTitle("Forgot password?", for: .normal)
        forgotButton.setTitleColor(.systemGreen, for: .normal)
        
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.addTarget(self, action: #selector(trySignIn), for: .touchDown)
        signInButton.backgroundColor = .systemGreen
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.titleEdgeInsets = UIEdgeInsets(top: 12, left: 45, bottom: 12, right: 45)
        signInButton.isEnabled = false
        signInButton.alpha = 0.6
        
        newUserButton.setTitle("New User? Sign Up", for: .normal)
        newUserButton.addAction {
            self.performSegue(withIdentifier: "newUserSegue", sender: self)
        }
        newUserButton.backgroundColor = .systemGreen
        newUserButton.setTitleColor(.white, for: .normal)
        newUserButton.titleEdgeInsets = UIEdgeInsets(top: 12, left: 45, bottom: 12, right: 45)
    }
    
    // MARK: UI
    private func redrawScene() {
        layout.activateConstraints(isPortrait: orientationIsPortrait())
    }
    
    override func viewDidLayoutSubviews() {
        redrawScene()
    }
    
    // MARK: Text Field Delegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 50
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: User Input
    @objc func usernameFieldDidChange() {
        usernameIsValid = isValidUsername(username: usernameField.text!)
        signInButton.isEnabled = usernameIsValid && passwordisValid
        signInButton.alpha = usernameIsValid && passwordisValid ? 1 : 0.6
    }
    
    @objc func passwordFieldDidChange() {
        passwordisValid = isValidPassword(password: passwordField.text!)
        signInButton.isEnabled = usernameIsValid && passwordisValid
        signInButton.alpha = usernameIsValid && passwordisValid ? 1 : 0.6
    }
    
    private func isValidUsername(username: String) -> Bool {
        return username.count > 2
    }
    
    private func isValidPassword(password: String) -> Bool {
        return password.count > 5
    }
    
    // MARK: Actions
    @objc func trySignIn() {
        guard let username = usernameField.text else {
            fatalError("Couldn't access username field")
        }
        guard let password = passwordField.text else {
            fatalError("Couldn't access password field")
        }
        
        let error = signIn(username: username, password: password)
        if error == nil {
            loadActiveUser(username: username)
            performSegue(withIdentifier: "signInSegue", sender: self)
        } else {
            let alert = UIAlertController(title: "Invalid login", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: false)
        }
    }
}
