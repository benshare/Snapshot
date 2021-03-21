//
//  EditClueViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/4/21.
//

import Foundation
import UIKit
import MapKit

class EditClueViewController: UIViewController, UITextViewDelegate & MKMapViewDelegate & UITextFieldDelegate {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var scrollView: ScrollableStackView!
    @IBOutlet weak var clueText: UITextView!
    @IBOutlet weak var clueLocation: MKMapView!
    @IBOutlet weak var hintView: UIStackView!
    private let mapCenter = MKPointAnnotation()
    
    // Layout
    private var layout: EditClueViewLayout!
    
    // Others
    var listIndex: Int!
    var clue: Clue!
    var parentController: EditHuntViewController!
    var clueType: RowType!
    var hunt: TreasureHunt!
    
    // MARK: Initialization
    override func viewDidLoad() {
        layout = EditClueViewLayout(navigationBar: navigationBar, scrollView: scrollView, clueLocation: clueLocation, clueText: clueText, hintView: hintView, clueType: clueType)
        layout.configureConstraints(view: view)
        layout.clue = clue
        
        // Navigation bar
        if clueType! == .clue {
            navigationBar.addBackButton(text: "< Back", action: {
                self.clueText.endEditing(true)
                for subview in self.hintView.arrangedSubviews {
                    if let field = subview as? UITextField {
                        field.endEditing(true)
                    }
                }
                self.parentController.processEditToClue(index: self.listIndex)
                self.dismiss(animated: true)
            })
            navigationBar.setTitle(text: "Edit Clue")
        } else {
            navigationBar.addBackButton(text: "< Back", action: {
                self.hunt.startingLocation = self.mapCenter.coordinate
                didUpdateActiveUser()
                self.dismiss(animated: true)
            })
            navigationBar.setTitle(text: "Set Starting Location")
        }
        view.bringSubviewToFront(navigationBar)
        
        // Map
        if clueType! == .clue {
            clueLocation.setCenter(clue.location, animated: false)
            clueLocation.setRegion(MKCoordinateRegion(center: clue.location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: false)
        } else {
            clueText.isHidden = true
            
            clueLocation.setCenter(hunt.startingLocation, animated: false)
            clueLocation.setRegion(MKCoordinateRegion(center: hunt.startingLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: false)
        }
        clueLocation.delegate = self
        clueLocation.addOneTimeTapEvent {
            self.layout.showFullViewMap(view: self.view, delegate: self)
        }
        mapCenter.title = clueType == .start ? "Starting Location" : "Clue Location"
        mapCenter.coordinate = clueLocation.centerCoordinate
        clueLocation.addAnnotation(mapCenter)
        
        // Text
        if clueType! == .clue {
            clueText.text = clue.text
            clueText.delegate = self
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:))))
        } else {
            clueText.isHidden = true
        }
        
        // Hints
        if clueType! == .clue {
            if hunt.allowHints {
                let label = UILabel()
                let labelRow = UIView()
                doNotAutoResize(views: [label, labelRow])
                labelRow.addSubview(label)
                NSLayoutConstraint.activate(
                    getSizeConstraints(widthAnchor: labelRow.widthAnchor, heightAnchor: labelRow.heightAnchor, sizeMap: [label: (0.2, 1)]) +
                    getSpacingConstraints(leftAnchor: labelRow.leftAnchor, widthAnchor: labelRow.widthAnchor, topAnchor: labelRow.topAnchor, heightAnchor: labelRow.heightAnchor, spacingMap: [label: (0.1, 0.5)], parentView: labelRow) +
                    [labelRow.heightAnchor.constraint(equalToConstant: 50)]
                )
                hintView.addArrangedSubview(labelRow)
                
                setLabelsToDefaults(labels: [label])
                label.text = "Hints:"
                label.textAlignment = .left
                
                if clue.hints.count > 0 {
                    for i in 0...clue.hints.count - 1 {
                        layout.addHintRow(delegate: self, hintText: clue.hints[i], initial: true)
                    }
                }
                if clue.hints.count < 3 {
                    layout.addPlusRow(delegate: self)
                }
            } else {
                let label = UILabel()
                let labelRow = UIView()
                doNotAutoResize(views: [label, labelRow])
                labelRow.addSubview(label)
                NSLayoutConstraint.activate(
                    getSizeConstraints(widthAnchor: labelRow.widthAnchor, heightAnchor: labelRow.heightAnchor, sizeMap: [label: (0.8, 1)]) +
                    getSpacingConstraints(leftAnchor: labelRow.leftAnchor, widthAnchor: labelRow.widthAnchor, topAnchor: labelRow.topAnchor, heightAnchor: labelRow.heightAnchor, spacingMap: [label: (0.5, 0.5)], parentView: labelRow) +
                    [labelRow.heightAnchor.constraint(equalToConstant: 30)]
                )
                hintView.addArrangedSubview(labelRow)
                
                setLabelsToDefaults(labels: [label])
                label.text = "Hints are disabled for this hunt."
                label.font = UIFont.italicSystemFont(ofSize: 20)
            }
        } else {
            hintView.isHidden = true
        }
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
        print("background tapped")
        clueText.endEditing(true)
        for subview in hintView.arrangedSubviews.prefix(upTo: hintView.arrangedSubviews.count - 1).suffix(from: 1) {
            let field = subview.subviews[0] as! UITextField
            field.endEditing(true)
        }
    }
    
    // MARK: MKMapViewDelegate
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        mapCenter.coordinate = mapView.centerCoordinate
    }
    
    // MARK: UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        self.clue.text = self.clueText.text
        didUpdateActiveUser()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        for hintIndex in 0...hintView.arrangedSubviews.count - 1 {
            let subview = hintView.arrangedSubviews[hintIndex + 1]
            if let field = subview.subviews[0] as? UITextField {
                if field == textField {
                    clue.hints[hintIndex] = textField.text!
                    didUpdateActiveUser()
                    return
                }
            }
        }
        fatalError("Didn't find field")
    }
}
