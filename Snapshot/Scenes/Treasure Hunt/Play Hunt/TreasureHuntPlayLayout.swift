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
    
    init(map: MKMapView, searchBar: UISearchBar, backButton: UIButton, cluesButton: UIButton, infoButton: UIButton) {

        doNotAutoResize(views: [map, backButton, cluesButton, infoButton])
        setLabelsToDefaults(labels: [])
        setButtonsToDefaults(buttons: [backButton, cluesButton, infoButton], withImageInsets: 10)
        
        backButton.backgroundColor = .lightGray
        backButton.setTitle("<", for: .normal)
        backButton.alpha = 0.8
        circularViews.append(backButton)
        
        cluesButton.setBackgroundImage(UIImage(named: "ScrollIcon"), for: .normal)
        infoButton.setBackgroundImage(UIImage(named: "QuestionMark"), for: .normal)
        
        // Portrait
        portraitSizeMap = [
            map: (1, 1),
            backButton: (0.15, 0),
            cluesButton: (0.12, 0),
            infoButton: (0.15, 0),
        ]
        
        portraitSpacingMap = [
            map: (0.5, 0.5),
            backButton: (0.12, 0.08),
            cluesButton: (0.12, 0.92),
            infoButton: (0.88, 0.92),
        ]
        
        // Landscape
        landscapeSizeMap = [
            map: (1, 1),
            backButton: (0, 0.15),
            cluesButton: (0, 0.12),
            infoButton: (0, 0.15),
        ]
        
        landscapeSpacingMap = [
            map: (0.5, 0.5),
            backButton: (0.08, 0.1),
            cluesButton: (0.08, 0.9),
            infoButton: (0.92, 0.9),
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
