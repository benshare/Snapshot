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
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = MemoryCollectionLayout(navigationBar: navigationBar, memoryList: memoryList, backButton: backButton, mapButton: mapButton, huntButton: huntButton)
        layout.configureConstraints(view: view)
        
        navigationBar.setTitle(text: "Collection")
        memoryList.addBorders(color: .black)
        fillListFromCollection()
        
        redrawScene()
        backButton.addAction {
            self.performSegue(withIdentifier: "backToMainSegue", sender: self)
        }
        mapButton.addAction {
            self.dismiss(animated: true, completion: {})
        }
    }
    
    private func fillListFromCollection() {
        let unsorted = getActiveCollection().collection.values
        for snapshot in unsorted.sorted(by: { return $0.time < $1.time }) {
            let row = layout.getRowForSnapshot(snapshot: snapshot)
            memoryList.addToStack(view: row)
        }
    }
    
    // MARK: UI
    private func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
        layout.updateCircleSizes()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout.updateCircleSizes()
        redrawScene()
    }
}
