//
//  MapViewController.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/2/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, MKMapViewDelegate {

    // MARK: Variables
    // Outlets
    @IBOutlet weak var map: MemoryMapView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var snapButton: UIButton!
    
    // Formatting
    private var layout: MapViewLayout!
    
    // Other variables
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation!
    private var shouldUpdateLocation = true
    var newMemoryView: NewMemoryView?
    var displayedCallout: SnapshotCalloutView?
    var fullImage: FullImageView?
    private var aggregatedDrag = CGPoint.zero
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mapBackgroundTapped)))
        
        layout = MapViewLayout(map: map, backButton: backButton, collectionButton: collectionButton, snapButton: snapButton)
        layout.configureConstraints(view: view)
        
        redrawScene()
        
        backButton.addAction {
            self.dismiss(animated: true)
        }
        collectionButton.addAction {
            self.performSegue(withIdentifier: "viewCollectionSegue", sender: self)
        }
        snapButton.addTarget(self, action: #selector(addSnapshotFromMap), for: .touchDown)
        
        startTrackingCurrentLocation()
    }
    
    func addCollectionToMap(collection: SnapshotCollection) {
        for snapshot in collection.collection.values {
            map.addSnapshot(snapshot: snapshot)
        }
    }
    
    // MARK: UI
    private func redrawScene() {
        let isPortrait = orientationIsPortrait()
        layout.activateConstraints(isPortrait: isPortrait)
        newMemoryView?.redrawScene(isPortrait: isPortrait)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout.updateCircleSizes()
        redrawScene()
    }
    
    func updateSnapButtonImage() {
        layout.updateSnapshotButtonImage()
    }
    
    private func doesViewContainPoint(region: UIView, point: CGPoint) -> Bool {
        let p = region.convert(point, from: view)
        return region.bounds.contains(p)
    }
    
    // MARK: Location
    func startTrackingCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateDisplayedLocation() {
        shouldUpdateLocation = false
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: true)
    }
        
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0] as CLLocation
        if shouldUpdateLocation {
            updateDisplayedLocation()
        }
        self.map.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager error: \(error.localizedDescription)")
    }
    
    // MARK: MKMapViewDelegate
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.addCollectionToMap(collection: getActiveCollection())
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "snapshot")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "snapshot")
            annotationView!.frame.size = CGSize(width: 250, height: 840)
            annotationView!.canShowCallout = false
            
            let imageView = UIImageView()
            annotationView!.addSubview(imageView)
            imageView.contentMode = .scaleAspectFill
            addFrame(imageView: imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: annotationView!.centerYAnchor).isActive = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(annotationTapped(sender:))))
            imageView.isUserInteractionEnabled = true
        } else {
            calloutForAnnotation(annotation: annotationView!)?.removeFromSuperview()
        }
        let snapshot = map.snapshotMap[annotation.title!!]!
        let imageView = annotationView!.subviews[0] as! UIImageView
        imageView.image = snapshot.image ?? UIImage(named: "SnapshotIcon")
        
        let calloutView = SnapshotCalloutView()
        annotationView!.addSubview(calloutView)
        calloutView.configureView(snapshot: snapshot, superview: annotationView!, controller: self)
        calloutView.isHidden = true
        
        return annotationView
    }
    
    @objc func mapBackgroundTapped(sender: UITapGestureRecognizer) {
        if displayedCallout == nil {
            return
        }
        if !doesViewContainPoint(region: displayedCallout!.contentView, point: sender.location(in: view)) {
            displayedCallout!.endEditing(true)
            displayedCallout!.hideCallout()
            displayedCallout = nil
        }
    }
    
    @objc func annotationTapped(sender: UITapGestureRecognizer) {
        if let annotationView = sender.view?.superview as? MKAnnotationView {
            let newCenter = CLLocationCoordinate2D(latitude: annotationView.annotation!.coordinate.latitude + map.region.span.latitudeDelta * 0.35, longitude: annotationView.annotation!.coordinate.longitude)
            let snapshotView = calloutForAnnotation(annotation: annotationView)!
            if snapshotView.isHidden {
                if displayedCallout != nil {
                    displayedCallout!.hideCallout()
                }
                view.bringSubviewToFront(snapshotView)
                snapshotView.displayCallout()
                displayedCallout = snapshotView
                map.setCenter(newCenter, animated: true)
            } else {
                snapshotView.hideCallout()
                displayedCallout = nil
            }
        } else {
            print("Unable to detect source annotation for tap")
        }
    }
    
    // MARK: New Snapshot
    @objc func addSnapshotFromMap() {
        newMemoryView = getNewMemoryView(parentView: view, parentController: self, location: CLLocation(latitude: map.centerCoordinate.latitude, longitude: map.centerCoordinate.longitude))
    }
    
    @objc func takePhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @objc func uploadPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    func addSnapshotToMap(snapshot: Snapshot) {
        map.addSnapshot(snapshot: snapshot)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        newMemoryView?.updateUploadedImage(image: image)
        dismiss(animated: true)
    }
    
    // MARK: Snapshot Callout
    private func calloutForAnnotation(annotation: MKAnnotationView) -> SnapshotCalloutView? {
        for subView in annotation.subviews as [UIView] {
            if (subView.isKind(of: SnapshotCalloutView.self)) {
                return subView as? SnapshotCalloutView
            }
        }
        return nil
    }
    
    func imageForAnnotation(annotation: MKAnnotationView) -> UIImageView? {
        for subView in annotation.subviews as [UIView] {
            if (subView.isKind(of: UIImageView.self)) {
                return subView as? UIImageView
            }
        }
        return nil
    }
    
    // MARK: Full Image
    func viewFullImage(calloutView: SnapshotCalloutView) {
        let fullView = FullImageView()
        view.addSubview(fullView)
        fullView.configureView(image: calloutView.image.image!, parentView: view)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragView(sender:))))
        self.fullImage = fullView
    }
    
    @objc func dragView(sender: UIPanGestureRecognizer) {
        let threshold: CGFloat = 250
        let translation = sender.translation(in: view)
        
        translatePointBy(point: &fullImage!.center, translation: translation)
        sender.setTranslation(CGPoint.zero, in: view)
        if fullImage!.center.x > view.center.x + 10 {
            fullImage!.center.x = view.center.x + 10
            fullImage!.alpha = 1
        } else if fullImage!.center.x < view.center.x - 10 {
            fullImage!.center.x = view.center.x - 10
        }

        let distance = distanceBetweenPoints(p1: fullImage!.center, p2: view.center)
        switch sender.state {
        case .ended:
            if distance < threshold {
                fullImage?.move(endingSize: fullImage!.frame.size, endingCenter: view.center, duration: 0.1)
                fullImage!.alpha = 1
            } else {
                fullImage!.removeFromSuperview()
            }
        default:
            fullImage!.alpha = max(1 - distance / threshold, 0.1)
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "viewCollectionSegue":
            let destination = segue.destination as! MemoryCollectionController
            destination.mapController = self
        default:
            fatalError("Unexpected segue identifier in map view: \(String(describing: segue.identifier))")
        }
    }
}
