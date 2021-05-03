//
//  EditClueViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/4/21.
//

import Foundation
import UIKit
import MapKit

class EditClueViewController: UIViewController, MKMapViewDelegate, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // MARK: Variables
    // Outlets
    @IBOutlet weak var navigationBar: NavigationBarView!
    @IBOutlet weak var scrollView: ScrollableStackView!
    @IBOutlet weak var clueLocation: MKMapView!
    @IBOutlet weak var clueText: UITextView!
    @IBOutlet weak var clueImage: UIImageView!
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
    private var shouldDismiss: Bool = false
    
    // MARK: Initialization
    override func viewDidLoad() {
        layout = EditClueViewLayout(navigationBar: navigationBar, scrollView: scrollView, clueLocation: clueLocation, clueText: clueText, clueImage: clueImage, hintView: hintView, clueType: clueType)
        layout.configureConstraints(view: view)
        layout.clue = clue
        
        if clueType! == .clue {
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditingText)))
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Navigation bar
        navigationBar.backgroundColor = SCENE_COLORS[.hunts]
        if clueType! == .clue {
            navigationBar.addBackButton(text: "Save", action: {
                syncActiveUser(attribute: .hunts)
                self.clueText.endEditing(true)
                for subview in self.hintView.arrangedSubviews {
                    if let field = subview as? UITextField {
                        field.endEditing(true)
                    }
                }
                self.parentController.processEditToClue(index: self.listIndex)
                self.dismiss(animated: true)
            }, color: .white)
            navigationBar.setTitle(text: "Edit Clue", color: .white)
        } else {
            navigationBar.addBackButton(text: "< Back", action: {
                self.hunt.startingLocation = self.mapCenter.coordinate
                self.dismiss(animated: true)
            }, color: .white)
            navigationBar.setTitle(text: "Set Starting Location", color: .white)
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
        } else {
            clueText.isHidden = true
        }
        
        // Image
        if clueType! == .clue {
            clueImage.image = clue.image ?? UIImage(named: "ClickToAdd")
            clueImage.addPermanentTapEvent {
                self.layout.showFullViewImage(view: self.view, cameraCallback: self.takePhoto, collectionCallback: self.choosePhotoFromCollection, libraryCallback: self.uploadPhoto)
            }
            clueImage.isUserInteractionEnabled = true
        } else {
            clueImage.isHidden = true
        }
        
        // Hints
        if clueType! == .clue {
            if hunt.allowHints {
                layout.addHintLabelRow()
                
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
    
    func updateMapAndImage() {
        clueLocation.setCenter(clue.location, animated: false)
        layout.fullImage.image = clue.image
        clueImage.image = clue.image
    }
    
    // MARK: Clue Text
    @objc func endEditingText() {
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
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                // This is needed when the textview tap overlaps with the keyboard
                shouldDismiss = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                    self.view.addOneTimeTapEvent {
                        self.shouldDismiss = true
                        self.endEditingText()
                    }
                })
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        for hintIndex in 0...hintView.arrangedSubviews.count - 1 {
            let subview = hintView.arrangedSubviews[hintIndex + 1]
            if let field = subview.subviews[0] as? UITextField {
                if field == textField {
                    clue.hints[hintIndex] = textField.text!
                    return
                }
            }
        }
        fatalError("Didn't find field")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if shouldDismiss {
            shouldDismiss = false
            return true
        }
        return false
    }
    
    // MARK: UIImagePickerControllerDelegate
    @objc func takePhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @objc func choosePhotoFromCollection() {
        performSegue(withIdentifier: "chooseFromCollectionSegue", sender: self)
    }
    
    @objc func uploadPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        clueImage.image = image
        layout.fullImage.image = image
        clue.image = image
        dismiss(animated: true)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chooseFromCollectionSegue":
            let dest = segue.destination as! MemoryCollectionController
            dest.popoverSource = self
        default:
            break
        }
    }
}
