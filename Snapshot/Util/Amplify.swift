//
//  Amplify.swift
//  Snapshot
//
//  Created by Benjamin Share on 4/3/21.
//

import Foundation
import Amplify
import AmplifyPlugins
import AWSPluginsCore
//import AWSMobileClient
import AWSCognitoIdentityProvider

private let encoder = JSONEncoder()
private let decoder = JSONDecoder()
public let ACTIVE_USER_GROUP = DispatchGroup()

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
func signIn(username: String, password: String) -> String {
    let group = DispatchGroup()
    group.enter()
    var message = String()
    
    let userAttributes = [AuthUserAttribute(.preferredUsername, value: username)]
    let options = AuthSignInRequest.Options(pluginOptions: userAttributes)
    Amplify.Auth.signIn(username: username, password: password, options: options) { result in
        switch result {
        case .success( _):
            do {
                let s = try String(describing: result.get().nextStep)
                if s.contains("confirm") {
                    message = "confirm"
                } else {
                    message = "success"
                }
            } catch {
                message = "Couldn't decode nextStep"
            }
            group.leave()
        case .failure(let error):
            message = error.errorDescription.description
            group.leave()
        }
    }
    group.wait()
    return message
}

// MARK: Sign Out
func signOutLocally() {
    Amplify.Auth.signOut() { result in
        switch result {
        case .success:
            break
        case .failure(let error):
            print("Sign out failed with error \(error)")
        }
    }
}

// MARK: Upload User Data
func syncActiveUser(attribute: UserCodingAttributes) {
    switch attribute {
    case .info:
        do {
            let data = try encoder.encode(activeUser.info)
            syncAttribute(data: data, key: UserCodingAttributes.info.rawValue)
        } catch {
            print("Failed to encode info data for upload")
        }
    case .preferences:
        do {
            let data = try encoder.encode(activeUser.preferences)
            syncAttribute(data: data, key: UserCodingAttributes.preferences.rawValue)
        } catch {
            print("Failed to encode preferences data for upload")
        }
    case .snapshots:
        do {
            let data = try encoder.encode(activeUser.snapshots)
            syncAttribute(data: data, key: UserCodingAttributes.snapshots.rawValue)
        } catch {
            print("Failed to encode snapshot data for upload")
        }
    case .privateHunts:
        do {
            let data = try encoder.encode(activeUser.privateHunts)
            syncAttribute(data: data, key: UserCodingAttributes.privateHunts.rawValue)
        } catch {
            print("Failed to encode private hunt data for upload")
        }
    case .sharedHunts:
        do {
            let data = try encoder.encode(activeUser.sharedHunts)
            syncAttribute(data: data, key: UserCodingAttributes.sharedHunts.rawValue)
        } catch {
            print("Failed to encode public hunt data for upload")
        }
    case .hunts:
        fatalError("No key value for 'hunts'")
    }
}

// All attributes
func syncActiveUser() {
    for attribute in [UserCodingAttributes.info, .preferences, .snapshots, .privateHunts, .sharedHunts] {
        syncActiveUser(attribute: attribute)
    }
}

private func syncAttribute(data: Data, key: String) {
    let options = StorageUploadDataRequest.Options(accessLevel: .private)
    Amplify.Storage.uploadData(key: key, data: data, options: options, resultListener: { (event) in
        switch event {
            case .success( _):
                break
            case .failure(let storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
        }
    })
}

// MARK: Load User Data
func doKeysExist(keys: [String]) -> [Bool] {
    var found = [Bool]()
    let group = DispatchGroup()
    group.enter()
    Amplify.Storage.list { event in
        switch event {
        case .success(let listResult):
            let foundKeys = listResult.items.map { $0.key }
            for key in keys {
                found.append(foundKeys.contains(key))
            }
        case .failure(let error):
            print(error.errorDescription)
            keys.forEach({ _ in found.append(false) })
        }
        group.leave()
    }
    group.wait()
    return found
}

func loadActiveUser(username: String) {
    ACTIVE_USER_GROUP.enter()
    activeUser = User(username: username)
    let options = StorageDownloadDataRequest.Options(accessLevel: .private)
    
    var updated = 0
    let found = doKeysExist(keys: [UserCodingAttributes.privateHunts.rawValue, UserCodingAttributes.sharedHunts.rawValue])
    let (privateFound, publicFound) = (found[0], found[1])
    let attrs = [UserCodingAttributes.info, .preferences, .snapshots, privateFound ? .privateHunts : .hunts] + (publicFound ? [UserCodingAttributes.sharedHunts] : [])
    for attribute in attrs {
        Amplify.Storage.downloadData(
            key: attribute.rawValue, options: options, resultListener: { (event) in
            switch event {
            case let .success(data):
                switch attribute {
                case .info:
                    do {
                        let info = try decoder.decode(AccountInfo.self, from: data)
                        activeUser.info = info
                    } catch {
                        print("Error while decoding account info")
                    }
                case .preferences:
                    do {
                        let info = try decoder.decode(UserPreferences.self, from: data)
                        activeUser.preferences = info
                    } catch {
                        print("Error while decoding user preferences")
                    }
                case .snapshots:
                    do {
                        let info = try decoder.decode(SnapshotCollection.self, from: data)
                        activeUser.snapshots = info
                    } catch {
                        print("Error while decoding snapshot collection")
                    }
                case .privateHunts, .hunts:
                    do {
                        let info = try decoder.decode(TreasureHuntCollection.self, from: data)
                        activeUser.privateHunts = info
                    } catch {
                        print("Error while decoding private hunt collection")
                    }
                case .sharedHunts:
                    do {
                        let info = try decoder.decode(TreasureHuntCollection.self, from: data)
                        activeUser.sharedHunts = info
                    } catch {
                        print("Error while decoding public hunt collection")
                    }
                }
                updated += 1
                if updated == attrs.count {
                    ACTIVE_USER_GROUP.leave()
                }
            case let .failure(storageError):
                print(storageError.errorDescription)
            }
        })
    }
}
