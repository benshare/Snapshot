//
//  LocationSearchTable.swift
//  Snapshot
//
//  Created by Benjamin Share on 5/9/21.
//

import Foundation
import UIKit

class LocationSearchTable: UITableViewController, UISearchResultsUpdating {
    
    // MARK: Variables
    
    // MARK: Initialization
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
