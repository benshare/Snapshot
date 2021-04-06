//
//  Login.swift
//  Snapshot
//
//  Created by Benjamin Share on 4/3/21.
//

import Foundation
import Amplify
import AmplifyPlugins

func initializeAmplify() {
    do {
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.configure()
    } catch {
        print("An error occurred while initializing Amplify: \(error)")
    }
}

func fetchCurrentAuthSession() {
    _ = Amplify.Auth.fetchAuthSession { result in
        switch result {
        case .success(let session):
            print("Is user signed in - \(session.isSignedIn)")
        case .failure(let error):
            print("Fetch session failed with error \(error)")
        }
    }
}

func signUp(username: String, password: String, email: String) {
    let userAttributes = [AuthUserAttribute(.email, value: email)]
    let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
    Amplify.Auth.signUp(username: username, password: password, options: options) { result in
        switch result {
        case .success(let signUpResult):
            if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails))")
            } else {
                print("SignUp Complete")
            }
        case .failure(let error):
            print("An error occurred while registering a user \(error)")
        }
    }
}

func confirmSignUp(for username: String, with confirmationCode: String) {
    Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
        switch result {
        case .success:
            print("Confirm signUp succeeded")
        case .failure(let error):
            print("An error occurred while confirming sign up \(error)")
        }
    }
}
