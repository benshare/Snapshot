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
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = MemoryCollectionLayout(navigationBar: navigationBar, memoryList: memoryList, huntButton: huntButton)
        layout.configureConstraints(view: view)
        
        navigationBar.setTitle(text: "Collection", color: .white)
        navigationBar.backgroundColor = SCENE_COLORS[.map]
        navigationBar.addBackButton(text: "< Back", action: { self.dismiss(animated: true, completion: nil) }, color: .white)
        
        // TODO: Enable hunt button
        huntButton.isHidden = true
        
        memoryList.addBorders(color: .black)
        fillListFromCollection()
        
        redrawScene()
    }
    
    private func fillListFromCollection() {
        let unsorted = activeUser.snapshots.collection.values
        for snapshot in unsorted.sorted(by: { return $0.time < $1.time }) {
            let row = layout.getRowForSnapshot(snapshot: snapshot)
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
}
