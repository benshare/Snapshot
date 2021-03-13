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
    var listIndexEditing: Int?
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7873589, longitude: -122.408227)
    
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
        view.bringSubviewToFront(clueList)
        
        addIconToView(view: preferences, name: "SettingsIcon")
        preferences.backgroundColor = .lightGray
        
        layout = EditHuntViewLayout(navigationBar: navigationBar, clueList: clueList, preferences: preferences)
        layout.configureConstraints(view: view)
    }
    
    func fillStack() {
        if hunt.clues.count > 0 {
            for ind in 0...hunt.clues.count - 1 {
                addRowToList(indInList: ind)
            }
        }
        let newClueView = UIView()
        clueList.addToStack(view: newClueView)
        addIconToView(view: newClueView, name: "PlusIcon")
        NSLayoutConstraint.activate([
            newClueView.widthAnchor.constraint(equalTo: clueList.widthAnchor),
            newClueView.heightAnchor.constraint(equalTo: clueList.heightAnchor, multiplier: 0.2),
        ])
        newClueView.addPermanentTapEvent {
            let loc = self.clueList.count() == 1 ? self.userLocation : (self.hunt.clues.last?.location)!
            let newClue = Clue(location: loc)
            self.hunt.clues.append(newClue)
            self.addRowToList(indInList: self.clueList.count() - 1)
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
    
    // MARK: Cells
    private func addRowToList(indInList: Int) {
        let clue = hunt.clues[indInList]
        
        if indInList > 1 {
            if let lastRow = clueList.elementAtIndex(index: clueList.count() - 1) as? ClueListRowView {
                lastRow.enableDownArrow()
            } else {
                (clueList.elementAtIndex(index: clueList.count() - 2) as! ClueListRowView).enableDownArrow()
            }
        }
        let row = ClueListRowView(index: indInList, text: clue.text)
        clueList.insertInStack(view: row, index: indInList)
        NSLayoutConstraint.activate([
            row.widthAnchor.constraint(equalTo: clueList.widthAnchor),
            row.heightAnchor.constraint(equalTo: clueList.heightAnchor, multiplier: 0.2),
        ])
        row.addPermanentTapEvent {
            self.clueEditing = clue
            self.listIndexEditing = indInList
            self.performSegue(withIdentifier: "editClueSegue", sender: self)
        }
        row.upArrow.addAction {
            self.swapCells(firstInd: row.index - 1)
        }
        row.downArrow.addAction {
            self.swapCells(firstInd: row.index)
        }
        row.deleteButton.addAction {
        }
        row.bringSubviewToFront(row.upArrow)
        row.bringSubviewToFront(row.downArrow)
        row.bringSubviewToFront(row.deleteButton)
        if indInList == 1 {
            row.disableUpArrow()
        }
        row.disableDownArrow()
    }
    
    func processEditToClue(index: Int) {
        let row = self.clueList.elementAtIndex(index: index) as! ClueListRowView
        row.updateClue(text: self.clueEditing!.text)
        clueEditing = nil
        listIndexEditing = nil
    }
    
    func swapCells(firstInd: Int) {
        print("Swapping indices \(firstInd) and \(firstInd + 1)")
        print("cluelist count = \(clueList.count())")
        let first = clueList.elementAtIndex(index: firstInd) as! ClueListRowView
        let second = clueList.elementAtIndex(index: firstInd + 1) as! ClueListRowView
        clueList.removeFromStack(view: second)
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
        default:
            fatalError("Unexpected segue from EditHuntView: \(String(describing: segue.identifier))")
        }
    }
}
