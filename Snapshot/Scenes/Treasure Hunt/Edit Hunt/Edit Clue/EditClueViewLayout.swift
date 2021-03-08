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
    private let startingButtonAndLabel: ButtonAndLabel
    private let endingButtonAndLabel: ButtonAndLabel
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(navigationBar: NavigationBarView, clueLocation: MKMapView, clueText: UITextView, startingButtonAndLabel: ButtonAndLabel, endingButtonAndLabel: ButtonAndLabel) {
        self.navigationBar = navigationBar
        self.clueLocation = clueLocation
        self.clueText = clueText
        self.startingButtonAndLabel = startingButtonAndLabel
        self.endingButtonAndLabel = endingButtonAndLabel

        doNotAutoResize(views: [navigationBar, clueLocation, clueText, startingButtonAndLabel, endingButtonAndLabel])
//        setLabelsToDefaults(labels: [])
//        setButtonsToDefaults(buttons: [isStartingButton, addImageButton])
        
        clueText.layer.borderWidth = 2
        clueText.layer.borderColor = UIColor.lightGray.cgColor
        clueText.font = UIFont.systemFont(ofSize: 20)
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            clueText: (0.7, 0.3),
            clueLocation: (0, 0.3),
//            startingButtonAndLabel: (0.25, 0.15),
//            endingButtonAndLabel: (0.25, 0.15),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            clueText: (0.5, 0.4),
            clueLocation: (0.5, 0.8),
//            startingButtonAndLabel: (0.33, 0.9),
//            endingButtonAndLabel: (0.67, 0.9),
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

class ButtonAndLabel: UIView {
    let button: UIButton
    let label: UILabel
    
    required init?(coder: NSCoder) {
        self.button = UIButton()
        self.label = UILabel()
        
        super.init(coder: coder)
        
        doNotAutoResize(views: [button, label])
        setButtonsToDefaults(buttons: [button])
        setLabelsToDefaults(labels: [label])
        
        self.addSubview(button)
        self.addSubview(label)
        let sizeMap: [UIView : (CGFloat, CGFloat)] = [
            button: (0.2, 0),
            label: (0.7, 1),
        ]
        let spacingMap: [UIView : (CGFloat, CGFloat)] = [
            button: (0.1, 0.5),
            label: (0.6, 0.5),
        ]
        let constraints = getSizeConstraints(widthAnchor: self.widthAnchor, heightAnchor: self.heightAnchor, sizeMap: sizeMap) + getSpacingConstraints(leftAnchor: self.leftAnchor, widthAnchor: self.widthAnchor, topAnchor: self.topAnchor, heightAnchor: self.heightAnchor, spacingMap: spacingMap, parentView: self)
        NSLayoutConstraint.activate(constraints)
    }
}
