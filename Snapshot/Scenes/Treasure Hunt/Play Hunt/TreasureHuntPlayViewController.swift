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
    var playthrough: TreasureHuntPlaythrough!
    var fullClueView: FullClueView!
    var cluesPopup: PopupOptionsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = TreasureHuntPlayLayout(map: map, backButton: backButton, cluesButton: cluesButton, infoButton: infoButton)

        layout!.configureConstraints(view: view)
        redrawScene()

        map.delegate = self
        let startingClue = playthrough.unlockClue()
        map.setCenter(startingClue.location, animated: false)
        map.setRegion(MKCoordinateRegion(center: startingClue.location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: false)
        
        backButton.addAction {
            self.dismiss(animated: true, completion: nil)
        }
        cluesButton.addAction(displayCluesPopup)
        displayClue(clue: startingClue, isNew: true)
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

    // MARK: Clues
    private func displayClue(clue: Clue, isNew: Bool, clueNum: Int? = nil) {
        fullClueView = FullClueView(text: clue.text, isNew: isNew, clueNum: clueNum)
        view.addSubview(fullClueView)
        fullClueView.configureView()
        doNotAutoResize(view: fullClueView)
        let clueConstraints = [
            fullClueView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            fullClueView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            fullClueView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fullClueView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ]
        NSLayoutConstraint.activate(clueConstraints)
        fullClueView.redrawScene()
        
        view.addTapEvent {
            NSLayoutConstraint.deactivate(clueConstraints)
            self.disappearVisibleClue()
            for subview in self.view.subviews {
                if subview.accessibilityIdentifier == "tapEventButton" {
                    subview.removeFromSuperview()
                    break
                }
            }
        }
    }
    
    private func disappearVisibleClue() {
        fullClueView.translatesAutoresizingMaskIntoConstraints = true
        fullClueView.frame = view.frame.applying(CGAffineTransform(scaleX: 0.8, y: 0.8))
        self.fullClueView.center = view.center
        self.fullClueView.layoutSubviews()
        UIView.animate(withDuration: 0.5, animations: {
            self.fullClueView.frame = self.cluesButton.frame
            self.fullClueView.layoutSubviews()
        }, completion: { _ in self.fullClueView.removeFromSuperview() })
    }
    
    private func displayCluesPopup() {
        cluesPopup = PopupOptionsView()
        for i in 0...playthrough.unlockedClues.count - 1 {
            let clue = playthrough.unlockedClues[i]
            cluesPopup.addButton(name: i == 0 ? "Starting Clue" : "Clue #\(i)", callback: {
                self.displayClue(clue: clue, isNew: false, clueNum: i)
                for subview in self.view.subviews {
                    if subview.accessibilityIdentifier == "tapEventButton" {
                        subview.removeFromSuperview()
                        break
                    }
                }
            })
        }
        view.addSubview(cluesPopup)
        doNotAutoResize(view: cluesPopup)
        NSLayoutConstraint.activate([
            cluesPopup.leftAnchor.constraint(equalTo: cluesButton.centerXAnchor),
            cluesPopup.bottomAnchor.constraint(equalTo: cluesButton.centerYAnchor),
        ])
        cluesPopup.configureView(setButtonDefaults: true)
        
        view.addTapEvent {
            self.cluesPopup.removeFromSuperview()
            for subview in self.view.subviews {
                if subview.accessibilityIdentifier == "tapEventButton" {
                    subview.removeFromSuperview()
                    break
                }
            }
        }
    }
}
