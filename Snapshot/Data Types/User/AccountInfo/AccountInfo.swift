//
//  AccountInfo.swift
//  Snapshot
//
//  Created by Benjamin Share on 5/2/21.
//

import Foundation

class AccountInfo: Codable {
    let username: String
    
    init(username: String) {
        self.username = username
    }
}
