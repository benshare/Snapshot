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
    var animationClueView: FullClueView!
    var staticClueView: FullClueView!
    var cluesPopup: PopupOptionsView!
    var nextLocation: CLLocationCoordinate2D!
    var checkForRadius: Bool = false
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = TreasureHuntPlayLayout(map: map, backButton: backButton, cluesButton: cluesButton, infoButton: infoButton)

        layout!.configureConstraints(view: view)
        redrawScene()

        map.delegate = self
        map.setRegion(MKCoordinateRegion(center: playthrough.hunt.startingLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: false)
        
        let currentClue = playthrough.getCurrentClue()
        nextLocation = currentClue.location
        checkForRadius = true
        displayClue(clue: currentClue, isNew: true, from: view)
        let annotation = MKPointAnnotation()
        annotation.coordinate = playthrough.hunt.startingLocation
        annotation.title = String(playthrough.currentClueNum + 1)
        map.addAnnotation(annotation)
        
        backButton.addAction {
            self.dismiss(animated: true, completion: nil)
        }
        cluesButton.addAction(displayCluesPopup)
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
    private func clueWasCompleted() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = playthrough.getCurrentClue().location
        if playthrough.unlockNextClue() {
            annotation.title = String(playthrough.currentClueNum + 1)
            map.addAnnotation(annotation)
            let newClue = playthrough.getCurrentClue()
            nextLocation = newClue.location
            checkForRadius = true
            displayClue(clue: newClue, isNew: true, from: view)
        } else {
            view.isUserInteractionEnabled = false
            let alert = UIAlertController(title: "Congrats!", message: "You finished the treasure hunt!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: {
                    action in
                self.dismiss(animated: true, completion: nil)
                }))
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func displayClue(clue: Clue, isNew: Bool, clueNum: Int? = nil, from: UIView, originOffset: CGPoint = .zero) {
        let startingSize = CGSize(width: view.frame.width * 0.1, height: view.frame.height * 0.1)
        let startingCenter = from.center + originOffset
        let endingSize = CGSize(width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.8)
        let endingCenter = self.view.center
        
        view.addOneTimeTapEvent {
            self.disappearVisibleClue(to: from, offset: originOffset)
        }
        animationClueView = FullClueView(clue: clue, parentController: self)
        view.addSubview(animationClueView)
        animationClueView.configureView(isNew: isNew, clueNum: clueNum)
        
        animationClueView.move(startingSize: startingSize, startingCenter: startingCenter, endingSize: endingSize, endingCenter: endingCenter, duration: 0.5, delay: isNew ? 1 : 0, completion: { _ in self.map.isUserInteractionEnabled = true
            
            self.animationClueView.isHidden = true
            self.staticClueView = FullClueView(clue: self.animationClueView.clue, parentController: self)
            self.staticClueView.configureView(isNew: self.animationClueView.isNew, clueNum: self.animationClueView.clueNum)
            self.view.addSubview(self.staticClueView)
            self.staticClueView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.staticClueView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.staticClueView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                self.staticClueView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
                self.staticClueView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8),
            ])
        })
    }
    
    private func disappearVisibleClue(to: UIView, offset: CGPoint = .zero) {
        staticClueView.isHidden = true
        animationClueView.isHidden = false
        animationClueView.frame = staticClueView.frame
        animationClueView.moveToAnchor(endingSize: CGSize(width: 50, height: 50), anchor: to, offset: offset, duration: 0.5, completion: { _ in self.animationClueView.removeFromSuperview() })
    }
    
    private func displayCluesPopup() {
        view.addOneTimeTapEvent {
            self.cluesPopup.removeFromSuperview()
        }
        
        cluesPopup = PopupOptionsView()
        for i in 0...playthrough.unlockedClues.count - 1 {
            let clue = playthrough.unlockedClues[i]
            cluesPopup.addButton(name: "Clue #\(i + 1)", callback: {
                self.displayClue(clue: clue, isNew: false, clueNum: i + 1, from: self.cluesButton)
                self.cluesPopup.removeFromSuperview()
                self.view.removeTapEvent()
            })
        }
        view.addSubview(cluesPopup)
        doNotAutoResize(view: cluesPopup)
        NSLayoutConstraint.activate([
            cluesPopup.leftAnchor.constraint(equalTo: cluesButton.centerXAnchor),
            cluesPopup.bottomAnchor.constraint(equalTo: cluesButton.centerYAnchor),
        ])
        cluesPopup.configureView(setButtonDefaults: true)
    }
    
    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView: MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: "clue")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "clue")
            annotationView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            annotationView.backgroundColor = .lightGray
            annotationView.alpha = 0.8
            
            let imageView = UIImageView(frame: annotationView.frame)
            annotationView.addSubview(imageView)
            imageView.image = UIImage(named: "ScrollIcon")
            
            let textView = UILabel(frame: annotationView.frame)
            setLabelsToDefaults(labels: [textView])
            textView.text = annotation.title!
            textView.font = UIFont.systemFont(ofSize: 30)
            textView.textColor = .white
            annotationView.addSubview(textView)
        } else {
            annotationView!.removeTapEvent()
            for subview in annotationView.subviews {
                if let textView = subview as? UILabel {
                    textView.text = annotation.title!
                }
            }
        }
        annotationView.annotation = annotation
        let index = Int(annotation.title!!)!
        annotationView.addPermanentTapEvent {
            self.displayClue(clue: self.playthrough.hunt.clues[index - 1], isNew: false, clueNum: index, from: annotationView)
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !checkForRadius {
            return
        }
        if isWithinRange(coordinate: map.centerCoordinate) {
            checkForRadius = false
            map.centerCoordinate = nextLocation
            map.isUserInteractionEnabled = false
            clueWasCompleted()
        }
    }
    
    func isWithinRange(coordinate: CLLocationCoordinate2D) -> Bool {
        let distance = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude).distance(from: CLLocation(latitude: nextLocation.latitude, longitude: nextLocation.longitude))
//        print("Distance: \(distance)")
        return Int(distance) < playthrough.hunt.clueRadius
    }
}
