//
//  EditClueViewLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/4/21.
//

import Foundation
import UIKit
import MapKit

class EditClueViewLayout {
    // MARK: Properties
    
    // UI elements
    private let navigationBar: NavigationBarView
    private let clueLocation: MKMapView
    private let clueText: UITextView
    private let isStartingButton: UIButton
    private let isStartingLabel: UILabel
    private let addImageButton: UIButton
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(navigationBar: NavigationBarView, clueLocation: MKMapView, clueText: UITextView, isStartingButton: UIButton, isStartingLabel: UILabel, addImageButton: UIButton) {
        self.navigationBar = navigationBar
        self.clueLocation = clueLocation
        self.clueText = clueText
        self.isStartingButton = isStartingButton
        self.isStartingLabel = isStartingLabel
        self.addImageButton = addImageButton

        doNotAutoResize(views: [navigationBar, clueLocation, clueText, isStartingButton, isStartingLabel, addImageButton])
        setLabelsToDefaults(labels: [isStartingLabel])
        setButtonsToDefaults(buttons: [isStartingButton, addImageButton])
        
        clueText.layer.borderWidth = 2
        clueText.layer.borderColor = UIColor.lightGray.cgColor
        clueText.font = UIFont.systemFont(ofSize: 20)
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            clueText: (0.7, 0.25),
            clueLocation: (0, 0.25),
            isStartingButton: (0, 0.05),
            isStartingLabel: (0, 0.15),
            addImageButton: (0, 0.07),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            clueText: (0.5, 0.4),
            clueLocation: (0.5, 0.7),
            isStartingButton: (0.2, 0.9),
            isStartingLabel: (0.4, 0.9),
            addImageButton: (0.75, 0.9),
        ]
        
        // Landscape
        landscapeSizeMap = [:
//            navigationBar: (, ),
//            clueLocation: (, ),
//            clueText: (, ),
//            isStartingButton: (, ),
//            addImageButton: (, ),
        ]
        
        landscapeSpacingMap = [:
//            navigationBar: (, ),
//            clueLocation: (, ),
//            clueText: (, ),
//            isStartingButton: (, ),
//            addImageButton: (, ),
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
}
