//
//  AccountPageController.swift
//  Snapshot
//
//  Created by Benjamin Share on 4/4/21.
//

import Foundation
import UIKit

class AccountPageController: UIViewController {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var scrollView: ScrollableStackView!
    
    // Layout
    private var layout: AccountPageLayout!
    
    
    // MARK: Initialization
    override func viewDidLoad() {
        layout = AccountPageLayout(navigationBar: navigationBar, scrollView: scrollView)
        layout.configureConstraints(view: view)
        
        navigationBar.setLeftItem(text: "< Back", action: {
            self.dismiss(animated: true)
        })
        navigationBar.setTitle(text: "Account Info")
        navigationBar.setRightItem(text: "Log out", action: self.logout)
        
        redrawScene()
    }

    // MARK: UI
    private func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
    }

    // MARK: Buttons
    func logout() {
        uploadHunts()
//        performSegue(withIdentifier: "logoutSegue", sender: self)
//        signOutLocally()
    }
}
