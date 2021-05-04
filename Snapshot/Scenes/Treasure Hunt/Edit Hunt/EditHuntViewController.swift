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
        layout = EditHuntViewLayout(navigationBar: navigationBar, clueList: clueList)
        layout.configureConstraints(view: view)
        
        navigationBar.setEditableTitle(background: clueList, text: hunt.name, placeholder: "Untitled Treasure Hunt", color: .white)
        navigationBar.backgroundColor = SCENE_COLORS[.hunts]
        navigationBar.addBackButton(text: "Save", action: {
            syncActiveUser(attribute: .hunts)
            self.parentController.reloadCell(index: self.index)
            self.dismiss(animated: true, completion: nil)
        }, color: .white)
        navigationBar.setRightItem(image: "SettingsIcon", tint: .white, action: {
            self.performSegue(withIdentifier: "huntPreferencesSegue", sender: self)
        })
        navigationBar.hunt = hunt
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:))))
        
        fillStack()
        clueList.addBorders(color: SCENE_COLORS[.hunts]!)
        view.bringSubviewToFront(navigationBar)
    }
    
    func fillStack() {
        let startingRow = ClueListRowView(index: 0, text: "")
        clueList.addToStack(view: startingRow)
        layout.addRowConstraints(row: startingRow)
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
        layout.addRowConstraints(row: newClueView)
        addIconToView(view: newClueView, name: "PlusIcon")
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
        layout.addRowConstraints(row: row)
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
        let row = clueList.elementAtIndex(index: listIndexEditing)
        NSLayoutConstraint.deactivate(row.constraints)
        layout.removeConstraintsForRow(row: row)
        clueList.removeFromStack(index: listIndexEditing)
        row.removeFromSuperview()
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
            destination.hunt = hunt
            destination.parentController = self
            destination.clueType = listIndexEditing == 0 ? .start : .clue
        case "huntPreferencesSegue":
            let destination = segue.destination as! EditHuntPreferencesController
            destination.hunt = hunt
        default:
            fatalError("Unexpected segue from EditHuntView: \(String(describing: segue.identifier))")
        }
    }
}
