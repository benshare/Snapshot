//
//  NewHuntViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/1/21.
//

import Foundation
import UIKit

class NewHuntViewController: UIViewController {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var clueList: ScrollableStackView!
    @IBOutlet weak var preferences: UIView!
    
    // Layout
    private var layout: NewHuntViewLayout!
    
    // MARK: Initialization
    override func viewDidLoad() {
        navigationBar.addBackButton(text: "< Back", action: { self.dismiss(animated: true) })
        navigationBar.setTitle(text: "Treasure Hunts")
        
        fillStack()
        clueList.addBorders()
        
        addIconToView(view: preferences, name: "SettingsIcon")
        preferences.backgroundColor = .lightGray
        
        layout = NewHuntViewLayout(navigationBar: navigationBar, clueList: clueList, preferences: preferences)
        layout.configureConstraints(view: view)
    }
    
    func fillStack() {
        for i in 1...10 {
            let row = ClueListRowView(index: i)
            clueList.addToStack(view: row)
            NSLayoutConstraint.activate([
                row.widthAnchor.constraint(equalTo: clueList.widthAnchor),
                row.heightAnchor.constraint(equalTo: clueList.heightAnchor, multiplier: 0.2),
            ])
        }
    }
    
    // MARK: UI
    private func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
        navigationBar.redrawScene()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        redrawScene()
    }
}
