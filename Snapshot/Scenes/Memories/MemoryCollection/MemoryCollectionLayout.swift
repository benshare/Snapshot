//
//  MemoryCollectionLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/22/21.
//

import Foundation
import UIKit

class MemoryCollectionLayout {
    // MARK: Properties
    
    // UI elements
    private let navigationBar: NavigationBarView
    private let memoryList: ScrollableStackView
    private let huntButton: UIButton
    
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
    
    // MARK: Initialization
    init(navigationBar: NavigationBarView, memoryList: ScrollableStackView, huntButton: UIButton) {
        self.navigationBar = navigationBar
        self.memoryList = memoryList
        self.huntButton = huntButton

        doNotAutoResize(views: [navigationBar, memoryList, huntButton])
        setLabelsToDefaults(labels: [])
        setButtonsToDefaults(buttons: [huntButton], withImageInsets: 10)
        circularViews.append(contentsOf: [huntButton])
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            memoryList: (1, 0.8),
            huntButton: (0.15, 0),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            memoryList: (0.5, 0.6),
            huntButton: (0.5, 0.92),
        ]
        
        // Landscape
        landscapeSizeMap = [
            navigationBar: (1, 0.3),
            memoryList: (1, 0.75),
            huntButton: (0.08, 0),
        ]
        
        landscapeSpacingMap = [
            navigationBar: (0.5, 0.1),
            memoryList: (0.5, 0.625),
            huntButton: (0.5, 0.9),
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
    
    func getRowForSnapshot(snapshot: Snapshot) -> UIView {
        let row = UIView()
        let image = UIImageView()
        let description = UILabel()
        let subrow = UIView()
        let creatorLabel = UILabel()
        let dateLabel = UILabel()
        doNotAutoResize(views: [row, image, description, creatorLabel, dateLabel, subrow])
        row.addSubview(image)
        row.addSubview(description)
        row.addSubview(subrow)
        subrow.addSubview(creatorLabel)
        subrow.addSubview(dateLabel)
        
        setLabelsToDefaults(labels: [description, creatorLabel, dateLabel])
        row.backgroundColor = .white
        image.image = snapshot.image
        description.text = (snapshot.title ?? "").isEmpty ? "No title" : snapshot.title!
        description.numberOfLines = 0
        description.font = UIFont.italicSystemFont(ofSize: 20)
        creatorLabel.text = "Created by: you"
        dateLabel.text = "Added on \(snapshot.time.toString(format: .monthDay))"
        
        portraitConstraints.append(row.widthAnchor.constraint(equalTo: row.heightAnchor, multiplier: 3))
        portraitConstraints += getSizeConstraints(widthAnchor: row.widthAnchor, heightAnchor: row.heightAnchor, sizeMap: [image: (0, 1), description: (0.6, 0.66), subrow: (0.66, 0.33)])
        portraitConstraints += getSpacingConstraints(leftAnchor: row.leftAnchor, widthAnchor: row.widthAnchor, topAnchor: row.topAnchor, heightAnchor: row.heightAnchor, spacingMap: [image: (0.167, 0.5), description: (0.66, 0.33), subrow: (0.66, 0.83)], parentView: row)
        portraitConstraints += getSizeConstraints(widthAnchor: subrow.widthAnchor, heightAnchor: subrow.heightAnchor, sizeMap: [creatorLabel: (0.3, 1), dateLabel: (0.3, 1)])
        portraitConstraints += getSpacingConstraints(leftAnchor: subrow.leftAnchor, widthAnchor: subrow.widthAnchor, topAnchor: subrow.topAnchor, heightAnchor: subrow.heightAnchor, spacingMap: [creatorLabel: (0.25, 0.5), dateLabel: (0.75, 0.5)], parentView: subrow)
        
        landscapeConstraints.append(row.widthAnchor.constraint(equalTo: row.heightAnchor, multiplier: 0.7))
        landscapeConstraints += getSizeConstraints(widthAnchor: row.widthAnchor, heightAnchor: row.heightAnchor, sizeMap: [image: (0, 0.4), description: (0.8, 0.25), subrow: (0.6, 0.25)])
        landscapeConstraints += getSpacingConstraints(leftAnchor: row.leftAnchor, widthAnchor: row.widthAnchor, topAnchor: row.topAnchor, heightAnchor: row.heightAnchor, spacingMap: [image: (0.5, 0.3), description: (0.5, 0.625), subrow: (0.5, 0.85)], parentView: row)
        landscapeConstraints += getSizeConstraints(widthAnchor: subrow.widthAnchor, heightAnchor: subrow.heightAnchor, sizeMap: [creatorLabel: (1, 0.5), dateLabel: (1, 0.5)])
        landscapeConstraints += getSpacingConstraints(leftAnchor: subrow.leftAnchor, widthAnchor: subrow.widthAnchor, topAnchor: subrow.topAnchor, heightAnchor: subrow.heightAnchor, spacingMap: [creatorLabel: (0.5, 0.25), dateLabel: (0.5, 0.75)], parentView: subrow)
        
        return row
    }
}
