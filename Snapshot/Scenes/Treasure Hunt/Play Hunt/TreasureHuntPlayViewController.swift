//
//  TreasureHuntPlayViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/8/21.
//

import Foundation
import UIKit
import MapKit

class TreasureHuntPlayViewController: UIViewController, MKMapViewDelegate {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cluesButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    // Formatting
    private var layout: TreasureHuntPlayLayout!
    
    // Data
    var hunt: TreasureHunt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = TreasureHuntPlayLayout(map: map, backButton: backButton, cluesButton: cluesButton, infoButton: infoButton)

        layout!.configureConstraints(view: view)
        redrawScene()

        map.delegate = self
        backButton.addAction {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: UI
    private func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout!.activateConstraints(isPortrait: isPortrait)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout!.updateCircleSizes()
        redrawScene()
    }

}
