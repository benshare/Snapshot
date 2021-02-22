//
//  NewMemoryViewLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/8/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class NewMemoryViewLayout {
    // MARK: Properties
    
    // UI elements
    private let titleLabel: UILabel
    private let mapLabel: UILabel
    private let map: MKMapView
    private let imageUploadView: ImageUploadView
//    private let libraryLabelButton: UIButton
//    private let imageButton: UIButton
    private let closeButton: UIButton
    private let submitButton: UIButton
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(closeButton: UIButton, titleLabel: UILabel, mapLabel: UILabel, map: MKMapView, imageUploadView: ImageUploadView, submitButton: UIButton) {
        self.titleLabel = titleLabel
        self.mapLabel = mapLabel
        self.map = map
        self.imageUploadView = imageUploadView
        self.closeButton = closeButton
        self.submitButton = submitButton

        doNotAutoResize(views: [titleLabel, mapLabel, map, imageUploadView, imageUploadView.cameraLabelButton, imageUploadView.libraryLabelButton, imageUploadView.imageButton, closeButton, submitButton])
        setTextToDefaults(labels: [titleLabel, mapLabel])
        setButtonsToDefaults(buttons: [closeButton], withInsets: 5)
        setButtonsToDefaults(buttons: [submitButton, imageUploadView.cameraLabelButton, imageUploadView.libraryLabelButton, imageUploadView.imageButton], withInsets: 10)
        
        closeButton.backgroundColor = .lightGray
        closeButton.layer.borderColor = UIColor.darkGray.cgColor
        closeButton.layer.borderWidth = 2
        
        submitButton.backgroundColor = .lightGray
        submitButton.layer.borderColor = UIColor.darkGray.cgColor
        submitButton.layer.borderWidth = 2
        submitButton.layer.cornerRadius = 10
        
        imageUploadView.imageButton.backgroundColor = .lightGray
        imageUploadView.imageButton.imageView?.contentMode = .scaleAspectFit
        
        // Portrait
        portraitSizeMap = [
            closeButton: (0.2, 0.07),
            titleLabel: (0.6, 0.1),
            mapLabel: (0.5, 0.1),
            map: (0.6, 0.25),
            imageUploadView: (0.6, 0.35),
            submitButton: (0.6, 0.1),
        ]
        
        portraitSpacingMap = [
            closeButton: (0.1, 0.035),
            titleLabel: (0.5, 0.1),
            mapLabel: (0.45, 0.18),
            map: (0.5, 0.33),
            imageUploadView: (0.5, 0.65),
            submitButton: (0.5, 0.9),
        ]
        
        // Landscape
        landscapeSizeMap = [
            closeButton: (0.15, 0.15),
            titleLabel: (0.4, 0.2),
            mapLabel: (0.3, 0.1),
            map: (0.3, 0.45),
            imageUploadView: (0.3, 0.55),
            submitButton: (0.35, 0.12),
        ]
        
        landscapeSpacingMap = [
            closeButton: (0.075, 0.075),
            titleLabel: (0.5, 0.12),
            mapLabel: (0.25, 0.27),
            map: (0.25, 0.57),
            imageUploadView: (0.75, 0.55),
            submitButton: (0.5, 0.9),
        ]
    }
    
    // MARK: Constraints
    
    func configureConstraints(view: UIView)  {
        view.backgroundColor = globalBackgroundColor()
        
        portraitConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: portraitSizeMap)
        portraitConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: portraitSpacingMap, parentView: view)
        portraitConstraints += imageUploadView.getPortraitConstraints()
        
        landscapeConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: landscapeSizeMap)
        landscapeConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: landscapeSpacingMap, parentView: view)
        landscapeConstraints += imageUploadView.getLandscapeConstraints()
        
        
    }
    
    func activateConstraints(isPortrait: Bool) {
        if isPortrait {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
        } else {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        }
    }
    
    // MARK: Other UI
    func setPickerImage(source: SnapshotSource) {
        imageUploadView.setMode(source: source)
    }
}
