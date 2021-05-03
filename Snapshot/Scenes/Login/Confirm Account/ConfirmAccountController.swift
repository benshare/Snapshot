//
//  ConfirmAccountController.swift
//  Snapshot
//
//  Created by Benjamin Share on 5/1/21.
//

import Foundation
import UIKit

class ConfirmAccountController: UIViewController, UITextFieldDelegate {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    // Formatting
    private var layout: ConfirmAccountLayout!

    // Other
    var username: String!
    var password: String!
    var number: String!
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
    
        layout = ConfirmAccountLayout(navigationBar: navigationBar, codeField: codeField, resendButton: resendButton, confirmButton: confirmButton)
        layout.configureConstraints(view: view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationBar.addBackButton(text: "< Back", action: { self.dismiss(animated: true)}, color: .white)
        navigationBar.setTitle(text: "Confirm Account", color: .white)
        navigationBar.backgroundColor = SCENE_COLORS[.account]
        
        codeField.delegate = self as UITextFieldDelegate
        codeField.placeholder = "######"
        
        resendButton.setTitle("Resend Code", for: .normal)
        resendButton.addTarget(self, action: #selector(resendCode), for: .touchDown)
        resendButton.setTitleColor(SCENE_COLORS[.account], for: .normal)
        
        confirmButton.setTitle("Submit", for: .normal)
        confirmButton.addTarget(self, action: #selector(submitCode), for: .touchDown)
        confirmButton.backgroundColor = SCENE_COLORS[.account]
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleEdgeInsets = UIEdgeInsets(top: 12, left: 45, bottom: 12, right: 45)
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
    
    // MARK: Actions
    @objc func submitCode() {
        guard let code = codeField.text else {
            fatalError("Couldn't access code field")
        }
        
        if confirmSignUp(for: username, with: code) {
            let error = signIn(username: username, password: password)
            if error == nil {
                activeUser = User(username: username)
                syncActiveUser()
                ACTIVE_USER_GROUP.wait()
                performSegue(withIdentifier: "confirmAccountSegue", sender: nil)
            } else {
                codeField.text = ""
                let alert = UIAlertController(title: "Account error", message: "Number verified, but couldn't sign in: \(error!)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { action in alert.dismiss(animated: true, completion: nil) }))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            codeField.text = ""
            let alert = UIAlertController(title: "Incorrect code", message: "Couldn't verify your account. Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { action in alert.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func resendCode() {
        resendConfirmationCode(for: username)
    }
}
