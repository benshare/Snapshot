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
        let locationConstraints = getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: [clueLocation: (0, 0.3)]) + getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: [clueLocation: (0.5, 0.8)], parentView: view)
        NSLayoutConstraint.activate(locationConstraints)
        clueLocation.addOneTimeTapEvent {
            self.layout.showFullViewMap(view: self.view, initialConstraints: locationConstraints)
        }
        
        mapCenter.title = "Clue Location"
        mapCenter.coordinate = clue.location
        clueLocation.addAnnotation(mapCenter)
        
        clueText.text = clue.text
        clueText.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:))))
        
        startingButtonAndLabel.isHidden = true
        endingButtonAndLabel.isHidden = true

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
        layout.updateCircleSizes()
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
    
//    func showFullViewMap(initialConstraints: [NSLayoutConstraint]) {
//        NSLayoutConstraint.deactivate(initialConstraints)
//        clueLocation.removeConstraints(initialConstraints)
//        view.bringSubviewToFront(clueLocation)
//
//        let newConstraints = getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: [clueLocation: (1, 1)]) + getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: [clueLocation: (1, 1)], parentView: view)
//        NSLayoutConstraint.activate(newConstraints)
//
//        let checkButton = UIButton()
//        doNotAutoResize(view: checkButton)
//        clueLocation.addSubview(checkButton)
//        checkButton.setBackgroundImage(UIImage(named: "CheckmarkIcon"), for: .normal)
//
//        let buttonConstraints = getSizeConstraints(widthAnchor: clueLocation.widthAnchor, heightAnchor: clueLocation.heightAnchor, sizeMap: [checkButton: (0.1, 0)]) + getSpacingConstraints(leftAnchor: clueLocation.leftAnchor, widthAnchor: clueLocation.widthAnchor, topAnchor: clueLocation.topAnchor, heightAnchor: clueLocation.heightAnchor, spacingMap: [checkButton: (0.9, 0.1)], parentView: clueLocation)
//        NSLayoutConstraint.activate(buttonConstraints)
//
//
//    }
}
