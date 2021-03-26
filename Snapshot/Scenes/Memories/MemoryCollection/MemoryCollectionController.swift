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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var huntButton: UIButton!
    
    // Formatting
    private var layout: MemoryCollectionLayout!
    
    // Other
    var mapController: MapViewController!
    var popoverSource: EditClueViewController?
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = MemoryCollectionLayout(navigationBar: navigationBar, memoryList: memoryList, backButton: backButton, mapButton: mapButton, huntButton: huntButton)
        layout.configureConstraints(view: view)
        
        navigationBar.setTitle(text: "Collection")
        memoryList.addBorders(color: .black)
        fillListFromCollection()
        
        redrawScene()
        if popoverSource != nil {
            mapButton.isHidden = true
            huntButton.isHidden = true
            backButton.addAction {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            backButton.addAction {
                self.performSegue(withIdentifier: "backToMainSegue", sender: self)
            }
            mapButton.addAction {
                self.dismiss(animated: true, completion: {})
            }
        }
    }
    
    private func fillListFromCollection() {
        let unsorted = getActiveCollection().collection.values
        for snapshot in unsorted.sorted(by: { return $0.time < $1.time }) {
            let row = layout.getRowForSnapshot(snapshot: snapshot)
            memoryList.addToStack(view: row)
            
            if popoverSource != nil {
                let source = popoverSource!
                row.addPermanentTapEvent {
                    source.clue.location = snapshot.location
                    source.clue.image = snapshot.image
                    didUpdateActiveUser()
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
}
