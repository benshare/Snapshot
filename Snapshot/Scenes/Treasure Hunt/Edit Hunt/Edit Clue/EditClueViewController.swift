//
//  EditClueViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/4/21.
//

import Foundation
import UIKit
import MapKit

class EditClueViewController: UIViewController, UITextViewDelegate & MKMapViewDelegate {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var clueLocation: MKMapView!
    @IBOutlet weak var clueText: UITextView!
    @IBOutlet weak var startingButtonAndLabel: ButtonAndLabel!
    @IBOutlet weak var endingButtonAndLabel: ButtonAndLabel!
    private let mapCenter = MKPointAnnotation()
    
    // Layout
    private var layout: EditClueViewLayout!
    
    // Data
    var listIndex: Int!
    var clue: Clue!
    var parentController: EditHuntViewController!
    
    // MARK: Initialization
    override func viewDidLoad() {
        navigationBar.addBackButton(text: "< Back", action: {
            self.clueText.endEditing(true)
            self.clue.text = self.clueText.text
            self.clue.location = self.mapCenter.coordinate
            didUpdateActiveUser()
            self.parentController.processEditToClue(index: self.listIndex)
            self.dismiss(animated: true)
        })
        navigationBar.setTitle(text: "Edit Clue")
        
        clueLocation.setCenter(clue.location, animated: false)
        clueLocation.setRegion(MKCoordinateRegion(center: clue.location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: false)
        clueLocation.delegate = self
        
        mapCenter.title = "Center"
        mapCenter.coordinate = clue.location
        clueLocation.addAnnotation(mapCenter)
        
        clueText.text = clue.text
        clueText.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:))))
        
        startingButtonAndLabel.isHidden = true
        endingButtonAndLabel.isHidden = true
//        startingButtonAndLabel.button.setBackgroundImage(UIImage(named: "checkboxEmpty"), for: .normal)
//        startingButtonAndLabel.button.setTitle("", for: .normal)
//        startingButtonAndLabel.label.text = "Starting clue?"
//
//        endingButtonAndLabel.button.setBackgroundImage(UIImage(named: "checkboxEmpty"), for: .normal)
//        endingButtonAndLabel.button.setTitle("", for: .normal)
//        endingButtonAndLabel.label.text = "Ending Message"

        layout = EditClueViewLayout(navigationBar: navigationBar, clueLocation: clueLocation, clueText: clueText, startingButtonAndLabel: startingButtonAndLabel, endingButtonAndLabel: endingButtonAndLabel)
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
    
    // MARK: MKMapViewDelegate
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        mapCenter.coordinate = mapView.centerCoordinate
    }
}