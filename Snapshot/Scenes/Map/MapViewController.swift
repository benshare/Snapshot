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
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var snapButton: UIButton!
    
    // Formatting
    private var layout: MapViewLayout!
    
    // Data
    
    // Other variables
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation!
    private var shouldUpdateLocation = true
    var newMemoryView: NewMemoryView?
    
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        layout = MapViewLayout(map: map, menuButton: menuButton, snapButton: snapButton, source: activeUser.preferences.defaultSource)
        layout.configureConstraints(view: view)
        
        snapButton.addTarget(self, action: #selector(addSnapshotFromMap), for: .touchDown)
        
        startTrackingCurrentLocation()
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
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager error: \(error.localizedDescription)")
    }
    
    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "snapshot")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "snapshot")
            annotationView!.canShowCallout = true
        }
        
        if annotation.title != nil && map.imageMap.keys.contains(annotation.title!!) {
            annotationView!.image = map.imageMap[annotation.title!!]
        } else {
            annotationView!.image = UIImage(named: "LibraryIcon")
        }
        annotationView?.frame.size = CGSize(width: 40, height: 40)
        return annotationView
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
}
