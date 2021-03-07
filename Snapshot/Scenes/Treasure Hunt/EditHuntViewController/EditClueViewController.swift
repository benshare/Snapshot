//
//  EditClueViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/4/21.
//

import Foundation
import UIKit
import MapKit

class EditClueViewController: UIViewController, UITextViewDelegate {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var clueLocation: MKMapView!
    @IBOutlet weak var clueText: UITextView!
    @IBOutlet weak var isStartingButton: UIButton!
    @IBOutlet weak var isStartingLabel: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    
    // Layout
    private var layout: EditClueViewLayout!
    
    // Data
    var index: Int!
    var clue: Clue!
    var parentController: EditHuntViewController!
    
    // MARK: Initialization
    override func viewDidLoad() {
        navigationBar.addBackButton(text: "< Back", action: {
            self.clueText.endEditing(true)
            self.clue.text = self.clueText.text
            didUpdateActiveUser()
            self.parentController.processEditToClue(index: self.index)
            self.dismiss(animated: true)
        })
        navigationBar.setTitle(text: "Edit Clue")
        
        clueLocation.setCenter(clue.location, animated: false)
        clueLocation.setRegion(MKCoordinateRegion(center: clue.location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: false)
        
        clueText.text = clue.text
        clueText.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:))))
        
        isStartingButton.setBackgroundImage(UIImage(named: "checkboxEmpty"), for: .normal)
        isStartingButton.setTitle("", for: .normal)
        isStartingButton.imageView?.contentMode = .scaleAspectFit
        
        isStartingLabel.text = "Starting clue?"
        
        addImageButton.setBackgroundImage(UIImage(named: "LibraryIcon"), for: .normal)
        addImageButton.setTitle("", for: .normal)
        addImageButton.imageView?.contentMode = .scaleAspectFit

        layout = EditClueViewLayout(navigationBar: navigationBar, clueLocation: clueLocation, clueText: clueText, isStartingButton: isStartingButton, isStartingLabel: isStartingLabel, addImageButton: addImageButton)
        layout.configureConstraints(view: view)
    }
    
    // MARK: UI
    private func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        redrawScene()
    }
    
    // MARK: Clue Text
    @objc func backgroundTapped(sender: UITapGestureRecognizer) {
        clueText.endEditing(true)
    }
}
