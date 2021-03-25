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
    private let backButton: UIButton
    private let mapButton: UIButton
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
    init(navigationBar: NavigationBarView, memoryList: ScrollableStackView, backButton: UIButton, mapButton: UIButton, huntButton: UIButton) {
        self.navigationBar = navigationBar
        self.memoryList = memoryList
        self.backButton = backButton
        self.mapButton = mapButton
        self.huntButton = huntButton

        doNotAutoResize(views: [navigationBar, memoryList, backButton, mapButton, huntButton])
        setLabelsToDefaults(labels: [])
        setButtonsToDefaults(buttons: [backButton, mapButton, huntButton], withImageInsets: 10)
        circularViews.append(contentsOf: [backButton, mapButton, huntButton])
        
        backButton.setTitle("<", for: .normal)
        backButton.alpha = 0.8
        
        mapButton.setImage(UIImage(named: "MapIcon"), for: .normal)
        mapButton.alpha = 0.8
        
        huntButton.setImage(UIImage(named: "TreasureIcon"), for: .normal)
        huntButton.backgroundColor = .darkGray
        huntButton.alpha = 0.8
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            memoryList: (1, 0.8),
            backButton: (0.15, 0),
            mapButton: (0.15, 0),
            huntButton: (0.15, 0),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            memoryList: (0.5, 0.6),
            backButton: (0.12, 0.1),
            mapButton: (0.88, 0.1),
            huntButton: (0.5, 0.9),
        ]
        
        // Landscape
        landscapeSizeMap = [:
//            navigationBar: (, ),
//            memoryList: (, ),
        ]
        
        landscapeSpacingMap = [:
//            navigationBar: (, ),
//            memoryList: (, ),
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
        
        var constraints = [NSLayoutConstraint]()
        constraints += [row.widthAnchor.constraint(equalTo: row.heightAnchor, multiplier: 3)]
        constraints += getSizeConstraints(widthAnchor: row.widthAnchor, heightAnchor: row.heightAnchor, sizeMap: [image: (0, 1), description: (0.6, 0.66), subrow: (0.66, 0.33)])
        constraints += getSpacingConstraints(leftAnchor: row.leftAnchor, widthAnchor: row.widthAnchor, topAnchor: row.topAnchor, heightAnchor: row.heightAnchor, spacingMap: [image: (0.167, 0.5), description: (0.66, 0.33), subrow: (0.66, 0.83)], parentView: row)
        constraints += getSizeConstraints(widthAnchor: subrow.widthAnchor, heightAnchor: subrow.heightAnchor, sizeMap: [creatorLabel: (0.3, 1), dateLabel: (0.3, 1)])
        constraints += getSpacingConstraints(leftAnchor: subrow.leftAnchor, widthAnchor: subrow.widthAnchor, topAnchor: subrow.topAnchor, heightAnchor: subrow.heightAnchor, spacingMap: [creatorLabel: (0.25, 0.5), dateLabel: (0.75, 0.5)], parentView: subrow)
        NSLayoutConstraint.activate(constraints)
        
        setLabelsToDefaults(labels: [description, creatorLabel, dateLabel])
        row.backgroundColor = .white
        image.image = snapshot.image
        description.text = (snapshot.title ?? "").isEmpty ? "No title" : snapshot.title!
        description.numberOfLines = 0
        description.font = UIFont.italicSystemFont(ofSize: 20)
        creatorLabel.text = "Created by: you"
        dateLabel.text = "Added on \(snapshot.time.toString(format: .monthDay))"
        
        return row
    }
}
