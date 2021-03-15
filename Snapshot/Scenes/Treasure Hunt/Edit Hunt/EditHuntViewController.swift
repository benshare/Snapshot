//
//  EditHuntViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/1/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

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
    var listIndexEditing: Int!
    
    // MARK: Initialization
    override func viewDidLoad() {
        navigationBar.addBackButton(text: "< Back", action: {
            self.parentController.reloadCell(index: self.index)
            self.dismiss(animated: true)
        })
        navigationBar.setEditableTitle(background: clueList, text: hunt.name, placeholder: "Untitled Treasure Hunt")
        navigationBar.hunt = hunt
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:))))
        
        fillStack()
        clueList.addBorders()
        view.bringSubviewToFront(navigationBar)
        
        addIconToView(view: preferences, name: "SettingsIcon")
        preferences.backgroundColor = .lightGray
        
        layout = EditHuntViewLayout(navigationBar: navigationBar, clueList: clueList, preferences: preferences)
        layout.configureConstraints(view: view)
    }
    
    func fillStack() {
        let startingRow = ClueListRowView(index: 0, text: "")
        clueList.addToStack(view: startingRow)
        NSLayoutConstraint.activate([
            startingRow.widthAnchor.constraint(equalTo: clueList.widthAnchor),
            startingRow.heightAnchor.constraint(equalTo: clueList.heightAnchor, multiplier: 0.16),
        ])
        startingRow.addPermanentTapEvent {
            self.listIndexEditing = 0
            self.performSegue(withIdentifier: "editClueSegue", sender: self)
        }
        
        if hunt.clues.count > 0 {
            for ind in 0...hunt.clues.count - 1 {
                addRowToList(clueIndex: ind)
            }
        }
        
        let newClueView = UIView()
        clueList.addToStack(view: newClueView)
        addIconToView(view: newClueView, name: "PlusIcon")
        NSLayoutConstraint.activate([
            newClueView.widthAnchor.constraint(equalTo: clueList.widthAnchor),
            newClueView.heightAnchor.constraint(equalTo: clueList.heightAnchor, multiplier: 0.16),
        ])
        newClueView.addPermanentTapEvent {
            let loc = self.hunt.clues.last?.location ?? self.hunt.startingLocation
            let newClue = Clue(location: loc)
            self.hunt.clues.append(newClue)
            self.addRowToList(clueIndex: self.hunt.clues.count - 1)
            if self.clueList.count() > 3 {
                if let row = self.clueList.elementAtIndex(index: self.clueList.count() - 3) as? ClueListRowView {
                    row.index = self.clueList.count() - 3
                    row.updateIndexLabel()
                }
            }
            didUpdateActiveUser()
            
            self.clueEditing = newClue
            self.listIndexEditing = self.clueList.count() - 2
            self.performSegue(withIdentifier: "newClueSegue", sender: self)
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
    
    // MARK: Cell Operations
    func processEditToClue(index: Int) {
        let row = self.clueList.elementAtIndex(index: index) as! ClueListRowView
        row.updateClue(text: self.clueEditing!.text)
        clueEditing = nil
    }
    
    // Add a cell
    private func addRowToList(clueIndex: Int) {
        let clue = hunt.clues[clueIndex]
        
        if clueIndex > 0 {
            if let lastRow = clueList.elementAtIndex(index: clueList.count() - 1) as? ClueListRowView {
                lastRow.enableDownArrow()
            } else {
                (clueList.elementAtIndex(index: clueList.count() - 2) as! ClueListRowView).enableDownArrow()
            }
        }
        let row = ClueListRowView(index: clueIndex + 1, text: clue.text)
        clueList.insertInStack(view: row, index: clueIndex + 1)
        NSLayoutConstraint.activate([
            row.widthAnchor.constraint(equalTo: clueList.widthAnchor),
            row.heightAnchor.constraint(equalTo: clueList.heightAnchor, multiplier: 0.16),
        ])
        row.addPermanentTapEvent {
            self.clueEditing = clue
            self.listIndexEditing = row.index
            self.performSegue(withIdentifier: "editClueSegue", sender: self)
        }
        row.upArrow.addAction {
            self.swapCells(firstInd: row.index - 1)
        }
        row.downArrow.addAction {
            self.swapCells(firstInd: row.index)
        }
        row.deleteButton.addAction {
            self.listIndexEditing = row.index
            self.displayDeleteAlert()
        }
        row.bringSubviewToFront(row.upArrow)
        row.bringSubviewToFront(row.downArrow)
        row.bringSubviewToFront(row.deleteButton)
        if clueIndex == 0 {
            row.disableUpArrow()
        }
        row.disableDownArrow()
    }
    
    // Remove a cell
    private func displayDeleteAlert() {
        let alert = UIAlertController(title: "Confirm Delete", message: "Delete clue?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
                action in
                self.deleteClue()
                alert.dismiss(animated: true, completion: nil)
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in alert.dismiss(animated: true, completion: nil) }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteClue() {
        clueList.removeFromStack(index: listIndexEditing)
        if hunt.clues.count > 1 {
            if listIndexEditing == 1 {
                (clueList.elementAtIndex(index: 1) as! ClueListRowView).disableUpArrow()
            }
            if listIndexEditing == hunt.clues.count {
                (clueList.elementAtIndex(index: listIndexEditing - 1) as! ClueListRowView).disableDownArrow()
            }
        }
        if clueList.count() - 1 > listIndexEditing {
            for index in listIndexEditing...clueList.count() - 2 {
                let row = clueList.elementAtIndex(index: index) as! ClueListRowView
                row.index = index
                row.updateIndexLabel()
            }
        }
        
        hunt.clues.remove(at: listIndexEditing - 1)
        didUpdateActiveUser()
    }
    
    // Swap cells
    func swapCells(firstInd: Int) {
        let first = clueList.elementAtIndex(index: firstInd) as! ClueListRowView
        let second = clueList.elementAtIndex(index: firstInd + 1) as! ClueListRowView
        clueList.removeFromStack(index: firstInd + 1, temporary: true)
        clueList.insertInStack(view: second, index: firstInd)
        
        first.index = firstInd + 1
        first.updateIndexLabel()
        second.index = firstInd
        second.updateIndexLabel()
        
        if firstInd == 1 {
            second.disableUpArrow()
            first.enableUpArrow()
        }
        if firstInd == clueList.count() - 3 {
            second.enableDownArrow()
            first.disableDownArrow()
        }
        
        let secondClue = hunt.clues.remove(at: firstInd)
        hunt.clues.insert(secondClue, at: firstInd - 1)
        didUpdateActiveUser()
    }
    
    // MARK: Clue Text
    @objc func backgroundTapped(sender: UITapGestureRecognizer) {
        navigationBar.endEditing(true)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "newClueSegue", "editClueSegue":
            let destination = segue.destination as! EditClueViewController
            destination.listIndex = listIndexEditing!
            destination.clue = clueEditing
            destination.parentController = self
            destination.clueType = listIndexEditing == 0 ? .start : .clue
            if listIndexEditing == 0 {
                destination.huntIfStart = hunt
            }
        default:
            fatalError("Unexpected segue from EditHuntView: \(String(describing: segue.identifier))")
        }
    }
}
