//
//  SnapshotCalloutViewLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/23/21.
//

import Foundation
import UIKit

class SnapshotCalloutViewLayout {
    // MARK: Properties
    
    // UI elements
    private let snapshotTitle: UITextField
    private let date: UILabel
    private let image: UIImageView
    private let expandButton: UIButton
    private let information: UITextField
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(snapshotTitle: UITextField, date: UILabel, image: UIImageView, expandButton: UIButton, information: UITextField) {
        self.snapshotTitle = snapshotTitle
        self.date = date
        self.image = image
        self.expandButton = expandButton
        self.information = information

        doNotAutoResize(views: [snapshotTitle, date, image, expandButton, information])
        setTextToDefaults(labels: [date])
        setButtonsToDefaults(buttons: [expandButton])
        
        snapshotTitle.textAlignment = .center
        
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.black.cgColor

//        snapshotTitle.isHidden = true
//        date.isHidden = true
//        image.isHidden = true
//        expandButton.isHidden = true
        information.isHidden = true
        
        // Portrait
        portraitSizeMap = [
            snapshotTitle: (0.7, 0.2),
            date: (0.2, 0.1),
            image: (0, 0.5),
            expandButton: (0.2, 0.1),
            information: (0.8, 0.4),
        ]
        
        portraitSpacingMap = [
            snapshotTitle: (0.5, 0.1),
            date: (0.5, 0.2),
            image: (0.5, 0.6),
            expandButton: (0.5, 0.9),
            information: (0.5, 0.8),
        ]
        
        // Landscape
        landscapeSizeMap = [
            snapshotTitle: (0.7, 0.2),
            date: (0.2, 0.1),
            image: (0, 0.5),
            expandButton: (0.2, 0.1),
            information: (0.8, 0.4),
        ]
        
        landscapeSpacingMap = [
            snapshotTitle: (0.5, 0.1),
            date: (0.5, 0.2),
            image: (0.5, 0.6),
            expandButton: (0.5, 0.9),
            information: (0.5, 0.8),
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
