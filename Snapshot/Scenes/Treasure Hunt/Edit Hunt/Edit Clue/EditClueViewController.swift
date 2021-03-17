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
    var clueType: RowType!
    var huntIfStart: TreasureHunt!
    
    // MARK: Initialization
    override func viewDidLoad() {
        if clueType! == .clue {
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
        } else {
            navigationBar.addBackButton(text: "< Back", action: {
                self.huntIfStart.startingLocation = self.mapCenter.coordinate
                didUpdateActiveUser()
                self.dismiss(animated: true)
            })
            navigationBar.setTitle(text: "Set Starting Location")
            
            clueText.isHidden = true
            
            clueLocation.setCenter(huntIfStart.startingLocation, animated: false)
            clueLocation.setRegion(MKCoordinateRegion(center: huntIfStart.startingLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: false)
        }
        
        clueLocation.delegate = self
        let sizeMap: [UIView: (CGFloat, CGFloat)] = clueType! == .clue ? [clueLocation: (0, 0.3)] : [clueLocation: (0, 0.5)]
        let spacingMap: [UIView: (CGFloat, CGFloat)] = clueType! == .clue ? [clueLocation: (0.5, 0.8)] : [clueLocation: (0.5, 0.5)]
        let locationConstraints = getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: sizeMap) + getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: spacingMap, parentView: view)
        NSLayoutConstraint.activate(locationConstraints)
        clueLocation.addOneTimeTapEvent {
            self.layout.showFullViewMap(view: self.view, initialConstraints: locationConstraints)
        }
        
        mapCenter.title = clueType == .start ? "Starting Location" : "Clue Location"
        mapCenter.coordinate = clueLocation.centerCoordinate
        clueLocation.addAnnotation(mapCenter)
        
        if clueType! == .clue {
            clueText.text = clue.text
            clueText.delegate = self
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:))))
        }
        
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
}
