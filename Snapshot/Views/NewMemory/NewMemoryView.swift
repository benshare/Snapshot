//
//  NewMemoryView.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/8/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class NewMemoryView: UIView, MKMapViewDelegate {
    // MARK: Variables
    // UI Elements
    private let titleLabel = UILabel()
    private let mapLabel = UILabel()
    private let map = MKMapView()
    private let mapCenter = MKPointAnnotation()
    private let imageUploadView = ImageUploadView()
    private let closeButton = UIButton()
    private let submitButton = UIButton()
    
    // Data
    var parentController: MapViewController!
    var uploadedImage: UIImage?
    var blurView: UIVisualEffectView!
    
    // Formatting
    private var layout: NewMemoryViewLayout!
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(location: CLLocation) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchDown)
        self.addSubview(closeButton)
        
        titleLabel.text = "New Snapshot"
        self.addSubview(titleLabel)
        
        mapLabel.text = "Confirm Snapshot Location:"
        self.addSubview(mapLabel)
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        map.setRegion(region, animated: true)
        map.delegate = self
        self.addSubview(map)
        
        mapCenter.title = "Center"
        mapCenter.coordinate = center
        map.addAnnotation(mapCenter)
        
        imageUploadView.setMode(source: activeUser.preferences.defaultSource)
        imageUploadView.imageButton.addTarget(self, action: #selector(uploadImage), for: .touchDown)
        self.addSubview(imageUploadView)
        self.addSubview(imageUploadView.cameraLabelButton)
        self.addSubview(imageUploadView.libraryLabelButton)
        self.addSubview(imageUploadView.imageButton)
        
        submitButton.setTitle("Create SnapShot", for: .normal)
        submitButton.addTarget(self, action: #selector(submitSnapshot), for: .touchDown)
        self.addSubview(submitButton)
        
        layout = NewMemoryViewLayout(closeButton: closeButton, titleLabel: titleLabel, mapLabel: mapLabel, map: map, imageUploadView: imageUploadView, submitButton: submitButton)
        layout.configureConstraints(view: self)
    }
    
    func redrawScene(isPortrait: Bool) {
        layout.activateConstraints(isPortrait: isPortrait)
    }
    
    // MARK: MapView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    // MARK: Image Upload
    @objc func uploadImage() {
        if imageUploadView.cameraLabelButton.isEnabled {
            parentController.uploadPhoto()
            activeUser.preferences.defaultSource = .library
        } else {
            parentController.takePhoto()
            activeUser.preferences.defaultSource = .camera
        }
        imageUploadView.imageUploaded = true
    }
    
    func updateUploadedImage(image: UIImage) {
        uploadedImage = image
        imageUploadView.imageButton.setImage(image, for: .normal)
    }
    
    // MARK: Close
    @objc private func closeView() {
        blurView?.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    @objc private func submitSnapshot() {
        let newSnapshot = Snapshot(id: activeUser.snapshots.nextId, location: mapCenter.coordinate, image: uploadedImage, time: Date())
        activeUser.snapshots.addSnapshot(snapshot: newSnapshot)
        syncActiveUser(attribute: .snapshots)
        parentController.addSnapshotToMap(snapshot: newSnapshot)
        parentController.updateSnapButtonImage()
        closeView()
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        mapCenter.coordinate = mapView.centerCoordinate
    }
}

// MARK: Image Upload View
class ImageUploadView: UIView {
    let cameraLabelButton = UIButton()
    let libraryLabelButton = UIButton()
    let imageButton = UIButton()
    
    private let cameraImage = UIImage(named: "CameraIcon")
    private let libraryImage = UIImage(named: "LibraryIcon")
    var imageUploaded = false
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        cameraLabelButton.setTitle("Open Camera", for: .normal)
        cameraLabelButton.addTarget(self, action: #selector(setCameraMode), for: .touchDown)
        
        libraryLabelButton.setTitle("Choose Photo", for: .normal)
        libraryLabelButton.addTarget(self, action: #selector(setLibraryMode), for: .touchDown)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getPortraitConstraints() -> [NSLayoutConstraint] {
        return getConstraints()
    }
    
    func getLandscapeConstraints() -> [NSLayoutConstraint] {
        return getConstraints()
    }
    
    private func getConstraints() -> [NSLayoutConstraint] {
        let sizeMap: [UIView : (CGFloat, CGFloat)] = [
            cameraLabelButton: (0.5, 0.2),
            libraryLabelButton: (0.5, 0.2),
            imageButton: (1, 0.8),
        ]
        
        let spacingMap: [UIView : (CGFloat, CGFloat)] = [
            cameraLabelButton: (0.25, 0.1),
            libraryLabelButton: (0.75, 0.1),
            imageButton: (0.5, 0.6),
        ]
        return getSizeConstraints(widthAnchor: self.widthAnchor, heightAnchor: self.heightAnchor, sizeMap: sizeMap) + getSpacingConstraints(leftAnchor: self.leftAnchor, widthAnchor: self.widthAnchor, topAnchor: self.topAnchor, heightAnchor: self.heightAnchor, spacingMap: spacingMap, parentView: self)
    }
    
    func setMode(source: SnapshotSource) {
        switch source {
        case .camera:
            cameraLabelButton.backgroundColor = .lightGray
            cameraLabelButton.setTitleColor(.gray, for: .normal)
            libraryLabelButton.backgroundColor = .gray
            libraryLabelButton.setTitleColor(.black, for: .normal)
            if !imageUploaded {
                imageButton.setImage(cameraImage, for: .normal)
            }
            cameraLabelButton.isEnabled = false
            libraryLabelButton.isEnabled = true
        case .library:
            cameraLabelButton.backgroundColor = .gray
            cameraLabelButton.setTitleColor(.black, for: .normal)
            libraryLabelButton.backgroundColor = .lightGray
            libraryLabelButton.setTitleColor(.gray, for: .normal)
            if !imageUploaded {
                imageButton.setImage(libraryImage, for: .normal)
            }
            cameraLabelButton.isEnabled = true
            libraryLabelButton.isEnabled = false
        }
    }
    
    @objc private func setCameraMode() {
        setMode(source: .camera)
    }
    
    @objc private func setLibraryMode() {
        setMode(source: .library)
    }
}

// MARK: Utility Functions
func getNewMemoryView(parentView: UIView, parentController: MapViewController, location: CLLocation) -> NewMemoryView {
    let newMemoryView = NewMemoryView(frame: parentView.frame)
    
    let blur = blurView(view: parentView)
    parentView.addSubview(newMemoryView)
    
    newMemoryView.configureView(location: location)
    newMemoryView.redrawScene(isPortrait: orientationIsPortrait())
    
    newMemoryView.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.9).isActive = true
    newMemoryView.heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: 0.9).isActive = true
    newMemoryView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
    newMemoryView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
    
    newMemoryView.parentController = parentController
    newMemoryView.blurView = blur
    parentController.newMemoryView = newMemoryView
    return newMemoryView
}
