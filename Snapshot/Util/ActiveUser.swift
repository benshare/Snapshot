//
//  ActiveUser.swift
//  Missing Link
//
//  Created by Benjamin Share on 11/30/20.
//  Copyright © 2020 Benjamin Share. All rights reserved.
//

import Foundation

private let userDefaults = UserDefaults.standard
var activeUser: User!

func updateSavedUsernameAndPassword(username: String, password: String) {
    let encoder = JSONEncoder()
    do {
        let usernameData = try encoder.encode(username)
        let passwordData = try encoder.encode(password)
        userDefaults.setValue(usernameData, forKey: "Username")
        userDefaults.setValue(passwordData, forKey: "Password")
    } catch {
        print("Failed to encode remembered username and password")
    }
}

func loadSavedUsernameAndPassword() -> (String, String)? {
    let decoder = JSONDecoder()
    do {
        if let usernameData = userDefaults.data(forKey: "Username")  {
            let username = try decoder.decode(String.self, from: usernameData)
            if let passwordData = userDefaults.data(forKey: "Password")  {
                let password = try decoder.decode(String.self, from: passwordData)
                return (username, password)
            }
        }
    } catch {
        print("Couldn't find saved username/password information")
    }
    return nil
}

func clearSavedUsernameAndPassword() {
    UserDefaults.resetDefaults()
}

extension UserDefaults {
    static func resetDefaults() {
        if let bundleId = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleId)
        }
    }
}
