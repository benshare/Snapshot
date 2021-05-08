//
//  MemoryCollectionController.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/22/21.
//

import Foundation
import UIKit

class MemoryCollectionController: UIViewController {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var memoryList: ScrollableStackView!
    @IBOutlet weak var huntButton: UIButton!
    
    // Formatting
    private var layout: MemoryCollectionLayout!
    
    // Other
    var mapController: MapViewController!
    var popoverSource: EditClueViewController?
    var editIsClicked: Bool = false
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = MemoryCollectionLayout(navigationBar: navigationBar, memoryList: memoryList, huntButton: huntButton)
        layout.configureConstraints(view: view)
        
        navigationBar.setTitle(text: "Collection", color: .white)
        navigationBar.backgroundColor = SCENE_COLORS[.map]
        navigationBar.addBackButton(text: "< Back", action: { self.dismiss(animated: true, completion: nil)
        }, color: .white)
        navigationBar.setRightItem(text: " Edit ", tint: .white, action: {
            if self.editIsClicked {
                self.layout.hideDeleteButtons()
                self.editIsClicked = false
                self.navigationBar.rightItem.setTitle(" Edit ", for: .normal)
            } else {
                self.layout.showDeleteButtons()
                self.editIsClicked = true
                self.navigationBar.rightItem.setTitle(" Done ", for: .normal)
            }
        })
        
        // TODO: Enable hunt button
        huntButton.isHidden = true
        
        memoryList.addBorders(color: .black)
        fillListFromCollection()
        
        redrawScene()
    }
    
    private func fillListFromCollection() {
        let unsorted = activeUser.snapshots.collection.map( { ($0.key, $0.value) })
        let sorted = unsorted.sorted(by: { return $0.1.time < $1.1.time })
        for index in 0...sorted.count - 1 {
            let snapshot = sorted[index].1
            let row = CollectionRowView(snapshot: snapshot, indexInCollection: sorted[index].0, indexInList: index, buttonCallback: {collectionIndex, listIndex in
                self.displayDeleteAlert(indexInCollection: collectionIndex, indexInList: listIndex)
            })
            memoryList.addToStack(view: row)
            
            if popoverSource != nil {
                let source = popoverSource!
                row.addPermanentTapEvent {
                    source.clue.location = snapshot.location
                    source.clue.image = snapshot.image
                    source.updateMapAndImage()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: UI
    private func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
        memoryList.setAxis(axis: isPortrait ? .vertical : .horizontal)
        layout.updateCircleSizes()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout.updateCircleSizes()
        redrawScene()
    }
    
    // MARK: Deletion
    private func displayDeleteAlert(indexInCollection: Int, indexInList: Int) {
        let alert = UIAlertController(title: "Confirm Delete", message: "Delete this snapshot from your collection?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
                action in
            self.deleteSnapshot(indexInCollection: indexInCollection, indexInList: indexInList)
                alert.dismiss(animated: true, completion: nil)
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in alert.dismiss(animated: true, completion: nil) }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteSnapshot(indexInCollection: Int, indexInList: Int) {
        activeUser.snapshots.removeSnapshot(index: indexInCollection)
        syncActiveUser(attribute: .snapshots)
        memoryList.removeFromStack(index: indexInList)
        if indexInList < memoryList.count() {
            for ind in indexInList...memoryList.count() - 1 {
                let row = memoryList.elementAtIndex(index: ind) as! CollectionRowView
                row.indexInList = row.indexInList - 1
            }
        }
    }
}
