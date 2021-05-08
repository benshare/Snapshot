//
//  CollectionRowLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 5/7/21.
//

import Foundation
import UIKit

class CollectionRowLayout: UILayout {
    // MARK: Properties
    
    // UI elements
    private let blurView: UIVisualEffectView
    private let deleteButton: UIButton
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // MARK: Initialization
    init(image: UIImageView, description: UILabel, creatorLabel: UILabel, dateLabel: UILabel, blurView: UIVisualEffectView, deleteButton: UIButton) {
        self.blurView = blurView
        self.deleteButton = deleteButton

        doNotAutoResize(views: [image, description, creatorLabel, dateLabel, blurView, deleteButton])
        setLabelsToDefaults(labels: [description, creatorLabel, dateLabel])
        setButtonsToDefaults(buttons: [deleteButton])
        
        // Portrait
        portraitSizeMap = [
            image: (0, 1),
            description: (0.6, 0.66),
            creatorLabel: (0.2, 0.33),
            dateLabel: (0.2, 0.33),
            blurView: (0, 1),
        ]
        
        portraitSpacingMap = [
            image: (0.167, 0.5),
            description: (0.66, 0.33),
            creatorLabel: (0.5, 0.83),
            dateLabel: (0.83, 0.83),
            blurView: (0.167, 0.5),
        ]
        
        // Landscape
        landscapeSizeMap = [
            image: (0, 0.4),
            description: (0.8, 0.25),
            creatorLabel: (0.5, 0.125),
            dateLabel: (0.5, 0.125),
            blurView: (0, 0.4),
        ]
        
        landscapeSpacingMap = [
            image: (0.5, 0.3),
            description: (0.5, 0.625),
            creatorLabel: (0.5, 0.8),
            dateLabel: (0.5, 0.9),
            blurView: (0.5, 0.3),
        ]
    }
    
    // MARK: Constraints
    func configureConstraints(view: UIView)  {
        view.backgroundColor = globalBackgroundColor()
        
        portraitConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: portraitSizeMap)
        portraitConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: portraitSpacingMap, parentView: view)
        
        landscapeConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: landscapeSizeMap)
        landscapeConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: landscapeSpacingMap, parentView: view)
        
        portraitConstraints.append(view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3))
        landscapeConstraints.append(view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7))
        
        NSLayoutConstraint.activate([
            deleteButton.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            deleteButton.heightAnchor.constraint(equalTo: blurView.heightAnchor, multiplier: 0.3),
            deleteButton.widthAnchor.constraint(equalTo: deleteButton.heightAnchor),
        ])
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
    func showDeleteButtons() {
        blurView.isHidden = false
        deleteButton.isHidden = false
    }
    
    func hideDeleteButtons() {
        blurView.isHidden = true
        deleteButton.isHidden = true
    }
}
