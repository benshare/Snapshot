//
//  EditHuntViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/1/21.
//

import Foundation
import UIKit
import MapKit

class EditHuntViewController: UIViewController, UITextFieldDelegate {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var clueList: ScrollableStackView!
    @IBOutlet weak var preferences: UIView!
    
    // Layout
    private var layout: EditHuntViewLayout!
    
    // Data
    var index: Int!
    var hunt: TreasureHunt!
    var parentController: TreasureHuntCollectionViewController!
    var clueEditing: Clue?
    var clueListIndex: Int?
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7873589, longitude: -122.408227)
    
    // MARK: Initialization
    override func viewDidLoad() {
        navigationBar.addBackButton(text: "< Back", action: {
            self.parentController.reloadCell(index: self.index)
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
                addRowToList(clueInd: ind)
            }
        }
        let newClueView = UIView()
        clueList.addToStack(view: newClueView)
        addIconToView(view: newClueView, name: "PlusIcon")
        NSLayoutConstraint.activate([
            newClueView.widthAnchor.constraint(equalTo: clueList.widthAnchor),
            newClueView.heightAnchor.constraint(equalTo: clueList.heightAnchor, multiplier: 0.2),
        ])
        newClueView.addTapEvent {
            let newClue = Clue(location: self.userLocation)
            self.hunt.clues.append(newClue)
            self.addRowToList(clueInd: self.clueList.count() - 1)
            didUpdateActiveUser()
            
            self.clueEditing = newClue
            self.clueListIndex = self.clueList.count() - 1
            self.performSegue(withIdentifier: "newClueSegue", sender: self)
        }
    }
    
    private func addRowToList(clueInd: Int) {
        let clue = hunt.clues[clueInd]
        let row = ClueListRowView(index: clueInd + 1, text: clue.text)
        clueList.addToStack(view: row)
        NSLayoutConstraint.activate([
            row.widthAnchor.constraint(equalTo: clueList.widthAnchor),
            row.heightAnchor.constraint(equalTo: clueList.heightAnchor, multiplier: 0.2),
        ])
        row.addTapEvent {
            self.clueEditing = clue
            self.clueListIndex = clueInd + 1
            self.performSegue(withIdentifier: "editClueSegue", sender: self)
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
    
    // MARK: Cells
    func processEditToClue(index: Int) {
        let row = self.clueList.elementAtIndex(index: index) as! ClueListRowView
        row.updateClue(text: self.clueEditing!.text)
        clueEditing = nil
        clueListIndex = nil
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "newClueSegue", "editClueSegue":
            let destination = segue.destination as! EditClueViewController
            destination.index = clueListIndex!
            destination.clue = clueEditing
            destination.parentController = self
        default:
            fatalError("Unexpected segue from EditHuntView: \(String(describing: segue.identifier))")
        }
    }
}
