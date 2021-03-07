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
    private let snapButton: UIButton
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(map: MemoryMapView, backButton: UIButton, snapButton: UIButton) {
        self.map = map
        self.backButton = backButton
        self.snapButton = snapButton

        doNotAutoResize(views: [map, backButton, snapButton])
        setLabelsToDefaults(labels: [])
        setButtonsToDefaults(buttons: [backButton, snapButton], withImageInsets: 10)
        
        backButton.backgroundColor = .lightGray
        backButton.setTitle("<", for: .normal)
        backButton.alpha = 0.8
        
        snapButton.backgroundColor = .lightGray
        snapButton.alpha = 0.8
        updateSnapshotButtonImage()
        
        // Portrait
        portraitSizeMap = [
            map: (1, 1),
            backButton: (0.2, 0),
            snapButton: (0.2, 0),
        ]
        
        portraitSpacingMap = [
            map: (0.5, 0.5),
            backButton: (0.17, 0.1),
            snapButton: (0.83, 0.1),
        ]
        
        // Landscape
        landscapeSizeMap = [
            map: (1, 1),
            backButton: (0, 0.2),
            snapButton: (0, 0.2),
        ]
        
        landscapeSpacingMap = [
            map: (0.5, 0.5),
            backButton: (0.1, 0.15),
            snapButton: (0.9, 0.15),
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
        makeViewCircular(view: backButton)
        makeViewCircular(view: snapButton)
    }
    
    func updateSnapshotButtonImage() {
        snapButton.setImage(UIImage(named: getActivePreferences().defaultSource == .camera ? "CameraIcon" : "LibraryIcon"), for: .normal)
    }
}
