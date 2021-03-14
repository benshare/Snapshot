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
    
    // Other
    private var circularViews = [UIView]()
    private var clueType: RowType
    
    init(navigationBar: NavigationBarView, clueLocation: MKMapView, clueText: UITextView, startingButtonAndLabel: ButtonAndLabel, endingButtonAndLabel: ButtonAndLabel, clueType: RowType = .clue) {
        self.navigationBar = navigationBar
        self.clueLocation = clueLocation
        self.clueText = clueText
        self.startingButtonAndLabel = startingButtonAndLabel
        self.endingButtonAndLabel = endingButtonAndLabel
        self.clueType = clueType

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
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            clueText: (0.5, 0.4),
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
    func updateCircleSizes() {
        makeViewsCircular(views: circularViews)
    }
    
    func showFullViewMap(view: UIView, initialConstraints: [NSLayoutConstraint]) {
        clueLocation.removeConstraints(initialConstraints)
        view.removeConstraints(initialConstraints)
        view.bringSubviewToFront(clueLocation)
        clueLocation.isUserInteractionEnabled = true
        
        let newConstraints = getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: [clueLocation: (1, 1)]) + getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: [clueLocation: (0.5, 0.5)], parentView: view)
        NSLayoutConstraint.activate(newConstraints)
        
        let checkButton = UIButton()
        doNotAutoResize(view: checkButton)
        clueLocation.addSubview(checkButton)
        checkButton.setBackgroundImage(UIImage(named: "CheckmarkIcon"), for: .normal)
        checkButton.alpha = 0.7
        
        let buttonConstraints = getSizeConstraints(widthAnchor: clueLocation.widthAnchor, heightAnchor: clueLocation.heightAnchor, sizeMap: [checkButton: (0.1, 0)]) + getSpacingConstraints(leftAnchor: clueLocation.leftAnchor, widthAnchor: clueLocation.widthAnchor, topAnchor: clueLocation.topAnchor, heightAnchor: clueLocation.heightAnchor, spacingMap: [checkButton: (0.9, 0.08)], parentView: clueLocation)
        NSLayoutConstraint.activate(buttonConstraints)
        
        checkButton.addAction {
            self.clueLocation.removeConstraints(newConstraints)
            view.removeConstraints(newConstraints)
            NSLayoutConstraint.activate(initialConstraints)
            checkButton.removeFromSuperview()
            self.clueLocation.addOneTimeTapEvent {
                self.showFullViewMap(view: view, initialConstraints: initialConstraints)
            }
        }
    }
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
