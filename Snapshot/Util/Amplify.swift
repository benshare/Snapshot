//
//  Amplify.swift
//  Snapshot
//
//  Created by Benjamin Share on 4/3/21.
//

import Foundation
import Amplify
import AmplifyPlugins

private let encoder = JSONEncoder()

// MARK: Initialize Amplify
func initializeAmplify() {
    do {
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.add(plugin: AWSS3StoragePlugin())
        try Amplify.configure()
    } catch {
        print("An error occurred while initializing Amplify: \(error)")
    }
}

func getLoggedInUser() -> String? {
    return Amplify.Auth.getCurrentUser()?.username
}

// MARK: Sign Up
func signUp(username: String, password: String, number: String) -> String? {
    let group = DispatchGroup()
    group.enter()
    var error: AuthError? = nil
    
    let userAttributes = [AuthUserAttribute(.preferredUsername, value: username), AuthUserAttribute(.phoneNumber, value: "+1" + number)]
    let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
    Amplify.Auth.signUp(username: username, password: password, options: options) { result in
        switch result {
        case .success( _):
            group.leave()
        case .failure(let e):
            error = e
            group.leave()
        }
    }
    group.wait()
    return error?.errorDescription.description
}

func confirmSignUp(for username: String, with confirmationCode: String) -> Bool {
    let group = DispatchGroup()
    group.enter()
    var success = false
    Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
        switch result {
        case .success( _):
            print("Confirm signUp succeeded")
            success = true
            group.leave()
        case .failure(let error):
            print("An error occurred while confirming sign up \(error)")
            success = false
            group.leave()
        }
    }
    group.wait()
    return success
}

func resendConfirmationCode(for username: String) {
    _ = Amplify.Auth.resendSignUpCode(for: username)
}

// MARK: Sign In
func signIn(username: String, password: String) -> String? {
    let group = DispatchGroup()
    group.enter()
    var error: AuthError? = nil
    
    let userAttributes = [AuthUserAttribute(.preferredUsername, value: username)]
    let options = AuthSignInRequest.Options(pluginOptions: userAttributes)
    Amplify.Auth.signIn(username: username, password: password, options: options) { result in
        switch result {
        case .success( _):
            group.leave()
        case .failure(let e):
            error = e
            group.leave()
        }
    }
    group.wait()
    return error?.errorDescription.description
}

// MARK: Sign Out
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

// MARK: Storage
func uploadHunts() {
    let dataString = "Logging out at \(Date())"
    let data = dataString.data(using: .utf8)!
    let options = StorageUploadDataRequest.Options(accessLevel: .private)
//    Amplify.Storage.uploadData(key: "Hunts", data: data,
    Amplify.Storage.uploadData(key: "Hunts", data: data, options: options,
                               resultListener: { (event) in
            switch event {
            case .success( _):
                break
            case .failure(let storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
        }
    })
//    do {
//        let data = try encoder.encode(activeUser.hunts)
//        Amplify.Storage.uploadData(key: "Hunts", data: data,
//            progressListener: { progress in
//                print("Progress: \(progress)")
//            }, resultListener: { (event) in
//                switch event {
//                case .success(let data):
//                    print("Completed: \(data)")
//                case .failure(let storageError):
//                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
//            }
//        })
//    } catch {
//        print("Failed to encode hunts for upload")
//    }
}
