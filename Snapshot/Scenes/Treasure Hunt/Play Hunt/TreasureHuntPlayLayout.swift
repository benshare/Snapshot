//
//  TreasureHuntPlayLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/8/21.
//

import Foundation
import UIKit
import MapKit

class TreasureHuntPlayLayout {
    // MARK: Properties
    
    // UI elements
    private let map: MKMapView
    private let backButton: UIButton
    private let cluesButton: UIButton
    private let infoButton: UIButton
    
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
    
    init(map: MKMapView, backButton: UIButton, cluesButton: UIButton, infoButton: UIButton) {
        self.map = map
        self.backButton = backButton
        self.cluesButton = cluesButton
        self.infoButton = infoButton

        doNotAutoResize(views: [map, backButton, cluesButton, infoButton])
        setLabelsToDefaults(labels: [])
        setButtonsToDefaults(buttons: [backButton, cluesButton, infoButton])
        
        backButton.backgroundColor = .lightGray
        backButton.setTitle("<", for: .normal)
        backButton.alpha = 0.8
        circularViews.append(backButton)
        
        cluesButton.backgroundColor = .lightGray
        cluesButton.setTitle("Clues", for: .normal)
        cluesButton.alpha = 0.8
        circularViews.append(cluesButton)
        
        infoButton.backgroundColor = .lightGray
        infoButton.setTitle("Info", for: .normal)
        infoButton.alpha = 0.8
        circularViews.append(infoButton)
        
        // Portrait
        portraitSizeMap = [
            map: (1, 1),
            backButton: (0.15, 0),
            cluesButton: (0.15, 0),
            infoButton: (0.15, 0),
        ]
        
        portraitSpacingMap = [
            map: (0.5, 0.5),
            backButton: (0.15, 0.1),
            cluesButton: (0.15, 0.9),
            infoButton: (0.85, 0.9),
        ]
        
        // Landscape
        landscapeSizeMap = [:
//            map: (, ),
//            backButton: (, ),
//            cluesButton: (, ),
//            infoButton: (, ),
        ]
        
        landscapeSpacingMap = [:
//            map: (, ),
//            backButton: (, ),
//            cluesButton: (, ),
//            infoButton: (, ),
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
}
