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
    private let menuButton: UIButton
    private let snapButton: UIButton
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(map: MemoryMapView, menuButton: UIButton, snapButton: UIButton) {
        self.map = map
        self.menuButton = menuButton
        self.snapButton = snapButton

        doNotAutoResize(views: [map, menuButton, snapButton])
        setTextToDefaults(labels: [])
        setButtonsToDefaults(buttons: [menuButton, snapButton], withImageInsets: 10)
        
        menuButton.backgroundColor = .lightGray
        menuButton.setImage(UIImage(named: "Menu2"), for: .normal)
        menuButton.alpha = 0.8
        menuButton.isHidden = true
        
        snapButton.backgroundColor = .lightGray
        snapButton.alpha = 0.8
        updateSnapshotButtonImage()
        
        // Portrait
        portraitSizeMap = [
            map: (1, 1),
            menuButton: (0.2, 0),
            snapButton: (0.2, 0),
        ]
        
        portraitSpacingMap = [
            map: (0.5, 0.5),
            menuButton: (0.17, 0.1),
            snapButton: (0.83, 0.1),
        ]
        
        // Landscape
        landscapeSizeMap = [
            map: (1, 1),
            menuButton: (0, 0.2),
            snapButton: (0, 0.2),
        ]
        
        landscapeSpacingMap = [
            map: (0.5, 0.5),
            menuButton: (0.1, 0.15),
            snapButton: (0.9, 0.15),
        ]
    }
    
    // MARK: Constraints
    func configureConstraints(view: UIView)  {
        let margins = view.layoutMarginsGuide
        view.backgroundColor = globalBackgroundColor()
        
        portraitConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: margins.heightAnchor, sizeMap: portraitSizeMap)
        portraitConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: margins.topAnchor, heightAnchor: margins.heightAnchor, spacingMap: portraitSpacingMap, parentView: view)
        
        landscapeConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: margins.heightAnchor, sizeMap: landscapeSizeMap)
        landscapeConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: margins.topAnchor, heightAnchor: margins.heightAnchor, spacingMap: landscapeSpacingMap, parentView: view)
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
        makeViewCircular(view: snapButton)
    }
    
    func updateSnapshotButtonImage() {
        snapButton.setImage(UIImage(named: activeUser.preferences.defaultSource == .camera ? "CameraIcon" : "LibraryIcon"), for: .normal)
    }
}
