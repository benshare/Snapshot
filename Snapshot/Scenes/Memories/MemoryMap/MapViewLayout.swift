//
//  MapViewLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/2/21.
//

import Foundation
import MapKit
import UIKit

class MapViewLayout {
    // MARK: Properties
    
    // UI elements
    private let map: MemoryMapView
    private let backButton: UIButton
    private let collectionButton: UIButton
    private let snapButton: UIButton
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    // Other
    private var circularViews = [UIView]()
    
    // MARK: Initialization
    init(map: MemoryMapView, backButton: UIButton, collectionButton: UIButton, snapButton: UIButton) {
        self.map = map
        self.backButton = backButton
        self.collectionButton = collectionButton
        self.snapButton = snapButton

        doNotAutoResize(views: [map, backButton, collectionButton, snapButton])
        setLabelsToDefaults(labels: [])
        setButtonsToDefaults(buttons: [backButton, collectionButton, snapButton], withImageInsets: 10)
        circularViews.append(contentsOf: [backButton, collectionButton, snapButton])
        
        backButton.setTitle("<", for: .normal)
        backButton.backgroundColor = .lightGray
        backButton.alpha = 0.8
        
        collectionButton.setImage(UIImage(named: "ListIcon"), for: .normal)
        collectionButton.backgroundColor = .lightGray
        collectionButton.alpha = 0.8
        
        snapButton.alpha = 0.8
        snapButton.backgroundColor = .lightGray
        updateSnapshotButtonImage()
        
        // Portrait
        portraitSizeMap = [
            map: (1, 1),
            backButton: (0.15, 0),
            collectionButton: (0.15, 0),
            snapButton: (0.15, 0),
        ]
        
        portraitSpacingMap = [
            map: (0.5, 0.5),
            backButton: (0.12, 0.08),
            collectionButton: (0.88, 0.08),
            snapButton: (0.5, 0.92),
        ]
        
        // Landscape
        landscapeSizeMap = [
            map: (1, 1),
            backButton: (0, 0.15),
            collectionButton: (0, 0.15),
            snapButton: (0, 0.15),
        ]
        
        landscapeSpacingMap = [
            map: (0.5, 0.5),
            backButton: (0.08, 0.1),
            collectionButton: (0.92, 0.1),
            snapButton: (0.5, 0.9),
        ]
    }
    
    // MARK: Constraints
    func configureConstraints(view: UIView)  {
        view.backgroundColor = globalBackgroundColor()
        
        portraitConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: portraitSizeMap)
        portraitConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: portraitSpacingMap, parentView: view)
        
        landscapeConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: landscapeSizeMap)
        landscapeConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: landscapeSpacingMap, parentView: view)
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
    func updateCircleSizes() {
        makeViewsCircular(views: circularViews)
    }
    
    func updateSnapshotButtonImage() {
        snapButton.setImage(UIImage(named: activeUser.preferences.defaultSource == .camera ? "CameraIcon" : "LibraryIcon"), for: .normal)
    }
}
