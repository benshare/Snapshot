//
//  NewAccountController.swift
//  Snapshot
//
//  Created by Benjamin Share on 5/1/21.
//

import Foundation
import UIKit

class NewAccountController: UIViewController, UITextFieldDelegate {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    // Formatting
    private var layout: NewAccountLayout!
    
    // Other
    private var usernameIsValid: Bool = false
    private var passwordisValid: Bool = false
    private var enteredUsername: String!
    private var enteredPassword: String!
    private var enteredNumber: String!
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout = NewAccountLayout(navigationBar: navigationBar, usernameField: usernameField, passwordField: passwordField, phoneField: phoneField, signUpButton: signUpButton)
        layout.configureConstraints(view: view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationBar.addBackButton(text: "< Back", action: { self.dismiss(animated: true)}, color: .white)
        navigationBar.setTitle(text: "Create Account", color: .white)
        navigationBar.backgroundColor = SCENE_COLORS[.main]
        
        usernameField.delegate = self as UITextFieldDelegate
        usernameField.addTarget(self, action: #selector(usernameFieldDidChange), for: .editingChanged)
        usernameField.placeholder = "Username"
        
        passwordField.delegate = self as UITextFieldDelegate
        passwordField.addTarget(self, action: #selector(passwordFieldDidChange), for: .editingChanged)
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Password"
        passwordField.addVisibilityIcon()
        
        phoneField.delegate = self as UITextFieldDelegate
        phoneField.addTarget(self, action: #selector(passwordFieldDidChange), for: .editingChanged)
        phoneField.placeholder = "xxx-xxx-xxxx"
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.addTarget(self, action: #selector(createAccount), for: .touchDown)
        signUpButton.backgroundColor = SCENE_COLORS[.main]
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.titleEdgeInsets = UIEdgeInsets(top: 12, left: 45, bottom: 12, right: 45)
        signUpButton.isEnabled = false
        signUpButton.alpha = 0.6
    }
    
    // MARK: UI
    private func redrawScene() {
        layout.activateConstraints(isPortrait: orientationIsPortrait())
        navigationBar.redrawScene()
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
        signUpButton.isEnabled = usernameIsValid && passwordisValid
        signUpButton.alpha = usernameIsValid && passwordisValid ? 1 : 0.6
    }
    
    @objc func passwordFieldDidChange() {
        passwordisValid = isValidPassword(password: passwordField.text!)
        signUpButton.isEnabled = usernameIsValid && passwordisValid
        signUpButton.alpha = usernameIsValid && passwordisValid ? 1 : 0.6
    }
    
    private func isValidUsername(username: String) -> Bool {
        return username.count > 2
    }
    
    private func isValidPassword(password: String) -> Bool {
        return password.count > 5
    }
    
    // MARK: Actions
    @objc func createAccount() {
        guard let username = usernameField.text else {
            fatalError("Couldn't access username field")
        }
        guard let password = passwordField.text else {
            fatalError("Couldn't access password field")
        }
        guard let number = phoneField.text else {
            fatalError("Couldn't access phone field")
        }
        
        let error = signUp(username: username, password: password, number: number)
        if error == nil {
            enteredUsername = username
            enteredPassword = password
            enteredNumber = number
            performSegue(withIdentifier: "createAccountSegue", sender: self)
        } else {
            let alert = UIAlertController(title: "Couldn't sign up", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: false)
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ConfirmAccountController
        dest.username = enteredUsername
        dest.password = enteredPassword
        dest.number = enteredNumber
    }
}
