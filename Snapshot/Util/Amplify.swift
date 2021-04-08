//
//  Amplify.swift
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

func signOutLocally() {
    Amplify.Auth.signOut() { result in
        switch result {
        case .success:
            print("Successfully signed out")
        case .failure(let error):
            print("Sign out failed with error \(error)")
        }
    }
}

func signUpOrError(username: String, password: String) -> String? {
    let group = DispatchGroup()
    group.enter()
    var error: AuthError? = nil
    let options = AuthSignUpRequest.Options(userAttributes: [AuthUserAttribute(.preferredUsername, value: username)])
    Amplify.Auth.signUp(username: username, password: password, options: options) { result in
        switch result {
        case .success(let signUpResult):
            if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails))")
            } else {
                print("SignUp Complete")
            }
        case .failure(let e):
            error = e
            print("An error occurred while registering a user \(e)")
        }
        group.leave()
    }
    group.wait()
    return error?.errorDescription.description
}

func signInOrError(username: String, password: String) -> String? {
    let group = DispatchGroup()
    group.enter()
    var error: AuthError? = nil
    Amplify.Auth.signIn(username: username, password: password) { result in
        switch result {
        case .success:
            print("Sign in succeeded")
            updateSavedUsernameAndPassword(username: username, password: password)
        case .failure(let e):
            error = e
            print("Sign in failed \(e)")
        }
        group.leave()
    }
    group.wait()
    return error?.errorDescription.description
}
