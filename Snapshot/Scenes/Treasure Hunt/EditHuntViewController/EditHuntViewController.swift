//
//  EditHuntViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/1/21.
//

import Foundation
import UIKit

class EditHuntViewController: UIViewController, UITextFieldDelegate {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var clueList: ScrollableStackView!
    @IBOutlet weak var preferences: UIView!
    
    // Layout
    private var layout: EditHuntViewLayout!
    
    // Data
    var hunt: TreasureHunt!
    var parentController: TreasureHuntCollectionViewController!
    
    // MARK: Initialization
    override func viewDidLoad() {
        navigationBar.addBackButton(text: "< Back", action: {
            print("Returning with hunt:\n\(self.hunt.name)")
            self.parentController.reloadView()
            self.dismiss(animated: true)
        })
        navigationBar.setEditableTitle(background: clueList, text: hunt.name, placeholder: "Untitled Treasure Hunt")
        navigationBar.hunt = hunt
        
        fillStack()
        clueList.addBorders()
        view.bringSubviewToFront(clueList)
        
        addIconToView(view: preferences, name: "SettingsIcon")
        preferences.backgroundColor = .lightGray
        
        layout = EditHuntViewLayout(navigationBar: navigationBar, clueList: clueList, preferences: preferences)
        layout.configureConstraints(view: view)
    }
    
    func fillStack() {
        if hunt.clues.count > 0 {
            for ind in 0...hunt.clues.count - 1 {
                let clue = hunt.clues[ind]
                let row = ClueListRowView(index: ind, text: clue.text)
                clueList.addToStack(view: row)
                NSLayoutConstraint.activate([
                    row.widthAnchor.constraint(equalTo: clueList.widthAnchor),
                    row.heightAnchor.constraint(equalTo: clueList.heightAnchor, multiplier: 0.2),
                ])
            }
        }
        let newClueView = UIView()
        clueList.addToStack(view: newClueView)
        addIconToView(view: newClueView, name: "PlusIcon")
        NSLayoutConstraint.activate([
            newClueView.widthAnchor.constraint(equalTo: clueList.widthAnchor),
            newClueView.heightAnchor.constraint(equalTo: clueList.heightAnchor, multiplier: 0.2),
        ])
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
