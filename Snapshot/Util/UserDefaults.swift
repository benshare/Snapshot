//
//  UserDefaults.swift
//  Missing Link
//
//  Created by Benjamin Share on 11/30/20.
//  Copyright © 2020 Benjamin Share. All rights reserved.
//

import Foundation

private let userDefaults = UserDefaults.standard

func updateSavedUser() {
    let encoder = JSONEncoder()
    do {
        let remembered_user = try encoder.encode(activeUser)
        userDefaults.setValue(remembered_user, forKey: "User")
    } catch {
        print("Failed to encode remembered user data")
    }
}

func loadActiveUserFromSaved() {
    let decoder = JSONDecoder()
    do {
        guard let defaultData = userDefaults.data(forKey: "User") else { return }
        activeUser = try decoder.decode(User.self, from: defaultData)
    } catch {    }
}

