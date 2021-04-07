//
//  ActiveUser.swift
//  Missing Link
//
//  Created by Benjamin Share on 11/30/20.
//  Copyright © 2020 Benjamin Share. All rights reserved.
//

import Foundation

private let userDefaults = UserDefaults.standard
private var activeUser: User!

func getActiveCollection() -> SnapshotCollection {
    return activeUser.snapshots
}

func getActiveHunts() -> TreasureHuntCollection {
    return activeUser.hunts
}

func getActivePreferences() -> UserPreferences {
    return activeUser.preferences
}

func didUpdateActiveUser() {
    updateSavedUser()
}

// Deprecate?
func updateActiveCollection(snapshot: Snapshot) {
    activeUser.snapshots.addSnapshot(snapshot: snapshot)
    updateSavedUser()
}

//func updateActiveHunts(snapshot: Snapshot) {
//    activeUser.snapshots.addSnapshot(snapshot: snapshot)
//    updateSavedUser()
//}

func updateActivePreferences(source: SnapshotSource) {
    activeUser.preferences.defaultSource = source
    updateSavedUser()
}

private func updateSavedUser() {
    let encoder = JSONEncoder()
    do {
        let userData = try encoder.encode(activeUser)
        userDefaults.setValue(userData, forKey: "User")
    } catch {
        print("Failed to encode remembered user data")
    }
}

func loadActiveUserFromSaved() {
    let decoder = JSONDecoder()
    do {
        if let defaultData = userDefaults.data(forKey: "User")  {
            activeUser = try decoder.decode(User.self, from: defaultData)
            return
        } else {
            print("Didn't find UserDefaults value for key \"User\"")
        }
    } catch {
        print("Couldn't decode saved data as User")
    }
    UserDefaults.resetDefaults()
    activeUser = User()
}

func getSavedUsernameAndPassword() -> (String, String)? {
    let decoder = JSONDecoder()
    do {
        if let usernameData = userDefaults.data(forKey: "Username")  {
            let username = try decoder.decode(String.self, from: usernameData)
            if let passwordData = userDefaults.data(forKey: "Username")  {
                let password = try decoder.decode(String.self, from: passwordData)
                return (username, password)
            }
        }
    } catch {
        print("Couldn't find saved username/password information")
    }
    return nil
}

extension UserDefaults {
    static func resetDefaults() {
        if let bundleId = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleId)
        }
    }
}
