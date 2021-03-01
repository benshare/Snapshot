//
//  TreasureHuntCollectionViewLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/28/21.
//

import Foundation
import UIKit

class TreasureHuntCollectionViewViewLayout {
    // MARK: Properties
    
    // UI elements
    private let backButton: UIButton
    private let titleLabel: UILabel
    private let collection: UICollectionView
    
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
    
    init(backButton: UIButton, titleLabel: UILabel, collection: UICollectionView) {
        self.backButton = backButton
        self.titleLabel = titleLabel
        self.collection = collection

        doNotAutoResize(views: [backButton, titleLabel, collection])
        setTextToDefaults(labels: [titleLabel])
        setButtonsToDefaults(buttons: [backButton], withInsets: 10)
        
        backButton.backgroundColor = .lightGray
        backButton.setTitle("<", for: .normal)
        backButton.alpha = 0.8
        circularViews.append(backButton)
        
        titleLabel.text = "Treasure Hunts"
        
        // Portrait
        portraitSizeMap = [
            backButton: (0.15, 0),
            titleLabel: (0.5, 0.2),
            collection: (1, 0.8),
        ]
        
        portraitSpacingMap = [
            backButton: (0.13, 0.1),
            titleLabel: (0.5, 0.1),
            collection: (0.5, 0.6),
        ]
        
        // Landscape
        landscapeSizeMap = [
            backButton: (0, 0.15),
            titleLabel: (0.5, 0.2),
            collection: (1, 0.8),
        ]
        
        landscapeSpacingMap = [
            backButton: (0.08, 0.15),
            titleLabel: (0.5, 0.1),
            collection: (0.5, 0.6),
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
    
    // MARK: Collection Cells
    func configureNewHuntCell(cell: UICollectionViewCell) {
        let moreButton = UIButton()
        moreButton.layer.borderColor = UIColor.lightGray.cgColor
        moreButton.layer.borderWidth = 3
        circularViews.append(moreButton)
        moreButton.setTitle("+", for: .normal)
        setButtonsToDefaults(buttons: [moreButton])
        moreButton.addOverlappingToParent(parent: cell)
    }
    
    func configureTreasureHuntCell(cell: UICollectionViewCell) {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        b.setTitle("Hello", for: .normal)
        b.backgroundColor = .green
        cell.contentView.addSubview(b)
    }
    
    
    // MARK: Other UI
    func updateCircleSizes() {
        makeViewsCircular(views: circularViews)
    }
}
