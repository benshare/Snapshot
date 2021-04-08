//
//  LoginPageController.swift
//  Snapshot
//
//  Created by Benjamin Share on 4/4/21.
//

import Foundation
import UIKit

class LoginPageController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var rememberLabel: UILabel!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var invalidLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!
    @IBOutlet weak var newUserButton: UIButton!
    
    // MARK: User info
    private var rememberedUser: User?
    private var userLoggingIn: User?
    
    // MARK: Values to track
    private var usernameIsValid: Bool = false
    private var passwordisValid: Bool = false
    private var isReturningUser: Bool = true
    
    // MARK: Formatting
    private var layout: LoginPageLayout!
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout = LoginPageLayout(titleLabel: titleLabel, welcomeLabel: welcomeLabel, usernameLabel: usernameLabel, usernameField: usernameField, passwordLabel: passwordLabel, passwordField: passwordField, showPasswordButton: showPasswordButton, rememberLabel: rememberLabel, rememberSwitch: rememberSwitch, invalidLabel: invalidLabel, signInButton: signInButton, guestButton: guestButton, newUserButton: newUserButton)
        layout.configureConstraints(view: view)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        usernameField.delegate = self as UITextFieldDelegate
        usernameField.addTarget(self, action: #selector(usernameFieldDidChange), for: .editingChanged)
        
        passwordField.delegate = self as UITextFieldDelegate
        passwordField.addTarget(self, action: #selector(passwordFieldDidChange), for: .editingChanged)
        passwordField.isSecureTextEntry = true
        
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        signInButton.addTarget(self, action: #selector(signIn), for: .touchDown)
        guestButton.addTarget(self, action: #selector(logInAsGuest), for: .touchDown)
        newUserButton.addTarget(self, action: #selector(toggleNewUser), for: .touchDown)
        
        if !isReturningUser {
            toggleNewUser()
        }
        
        // Fetch data
        fetchCurrentAuthSession()
        let (username, password) = getSavedUsernameAndPassword() ?? (nil, nil)
        if username == nil {
            print("Found no saved user data")
            signOutLocally()
        } else {
            let error = signInOrError(username: username!, password: password!)
            if error == nil {
                performSegue(withIdentifier: "returningUserSegue", sender: self)
            } else {
                print("Found saved user info but couldn't log in")
                signOutLocally()
            }
        }
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
    }
    
    @objc func passwordFieldDidChange() {
        passwordisValid = isValidPassword(password: passwordField.text!)
        signInButton.isEnabled = usernameIsValid && passwordisValid
    }
    
    private func isValidUsername(username: String) -> Bool {
        return username.count > 2
    }
    
    private func isValidPassword(password: String) -> Bool {
        return password.count > 5
    }

    private func doesPasswordConvertToHash(username: String, password: String, hash: String) -> Bool {
        return passwordHashFunction(username, password) == hash
    }
    

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let homepage = segue.destination as! HomePageViewController
        
//        fetchVisiblePackData()
//        fetchDataForPacks(packs: getDefaultUnlockedPackNames())
//        fetchAggregatePackData(progresses: [:])
//        fetchVisiblePackData()
//        fetchAggregatePackData(progresses: userLoggingIn!.progress.pack_progresses)
        
//        var loggedInUser: LoggedInUser
//        switch segue.identifier {
//        case "newUserSegue":
//            homepage.shouldDisplayTutorialAlert = true
//            fallthrough
//        case "returningUserSegue":
//            loggedInUser = LoggedInUser(user: userLoggingIn!, rememberMe: rememberSwitch.isOn)
//            loggedInUser.isGuest = false
//        case "guestSegue":
//            userLoggingIn = User(username: "", password: "")
//            loggedInUser = LoggedInUser(user: userLoggingIn!, rememberMe: false)
//            loggedInUser.isGuest = true
//            homepage.shouldDisplayTutorialAlert = true
//        case "feedbackButton":
//            fatalError("Feedback button not implemented from login page")
//        default:
//            fatalError("Unexpected segue from login page.")
//        }
//        homepage.loggedInUser = loggedInUser
//        if !loggedInUser.isGuest {
//            setUserToSync(user: loggedInUser.user, remember: loggedInUser.rememberMe)
//        }
        
        // Reset UI
        layout.setUIDefaults()
    }

    // MARK: Buttons
    @objc func togglePasswordVisibility() {
        if showPasswordButton.titleLabel!.text == "Show" {
            passwordField.isSecureTextEntry = false
            showPasswordButton.setTitle("Hide", for: .normal)
        } else {
            passwordField.isSecureTextEntry = true
            showPasswordButton.setTitle("Show", for: .normal)
        }
    }
    
    @objc func signIn() {
        if isReturningUser {
            guard var username = usernameField.text else {
                fatalError("Couldn't access username field")
            }
            guard let password = passwordField.text else {
                fatalError("Couldn't access password field")
            }
            username = username.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let error = signInOrError(username: username, password: password)
            if error == nil {
                performSegue(withIdentifier: "returningUserSegue", sender: self)
            } else {
                let alert = UIAlertController(title: "Invalid login", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: false)
            }
        } else {
            guard let username = usernameField.text else {
                fatalError("Couldn't access username field")
            }
            guard let password = passwordField.text else {
                fatalError("Couldn't access password field")
            }
            let error = signUpOrError(username: username, password: password)
            if error == nil {
                performSegue(withIdentifier: "newUserSegue", sender: self)
            } else {
                let alert = UIAlertController(title: "Invalid login", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: false)
            }
            
//            let newUser = User(username: username, password: password)
//            if createAccountForUser(user: newUser) {
//                userLoggingIn = newUser
//                if rememberSwitch.isOn {
//                    writeUserToDefaultsNoCheck(user: userLoggingIn!)
//                }
//            } else {
//                invalidLabel.text = "Username already exists. Try again."
//                invalidLabel.isHidden = false
//            }
        }
    }
    
    @objc func toggleNewUser() {
        isReturningUser = !isReturningUser
        if isReturningUser {
            layout.switchToReturningUser()
        } else {
            layout.switchToNewUser()
        }
    }
    
    @objc func logInAsGuest() {
        performSegue(withIdentifier: "guestSegue", sender: self)
    }
    
    func logInRememberedUser(user: User) {
//        let info = getLoginForUser(user: user)
//        if !info.found || user.passwordHash != info.hash {
//            print("Remembered user contains outdated information, deleting.\n")
//            clearRememberedUser()
//            return
//        }
//
//        userLoggingIn = user
//        let fetched = getFullProgressForUser(user: userLoggingIn!)
//        resolveRememberedAndFetchedProgresses(rememberedUser: userLoggingIn!, fetchedProgress: fetched)
//        userLoggingIn?.data.playData.updateTodayIfExpired()
//        userLoggingIn?.data.dailyData.updateStreakIfExpired()
//        writeUserToDefaultsNoCheck(user: userLoggingIn!)
//        rememberSwitch.isOn = true
        performSegue(withIdentifier: "returningUserSegue", sender: self)
    }
}
