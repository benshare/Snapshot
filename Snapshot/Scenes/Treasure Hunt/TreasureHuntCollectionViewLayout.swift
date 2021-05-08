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
    private let navigationBar: NavigationBarView
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
    
    init(navigationBar: NavigationBarView, titleLabel: UILabel, collection: UICollectionView) {
        self.navigationBar = navigationBar
        self.titleLabel = titleLabel
        self.collection = collection

        doNotAutoResize(views: [navigationBar, titleLabel, collection])
        setLabelsToDefaults(labels: [titleLabel])
        
        titleLabel.isHidden = true
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            collection: (1, 0.8),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            collection: (0.5, 0.6),
        ]
        
        // Landscape
        landscapeSizeMap = [
            navigationBar: (1, 0.3),
            collection: (1, 0.7),
        ]
        
        landscapeSpacingMap = [
            navigationBar: (0.5, 0.15),
            collection: (0.5, 0.65),
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
    
    // MARK: Collection Cells
    func configureNewHuntCell(cell: UICollectionViewCell) {
        let ratio: CGFloat = 0.7
        let minX = cell.frame.minX * ratio + cell.frame.midX * (1 - ratio)
        let minY = cell.frame.minY * ratio + cell.frame.midY * (1 - ratio)
        let button = UIButton(frame: CGRect(x: minX, y: minY, width: cell.frame.width * ratio, height: cell.frame.height * ratio))
        cell.contentView.addSubview(button)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 70)
        let color = SCENE_COLORS[.hunts]
        button.setTitleColor(color?.darker(), for: .normal)
        button.layer.borderColor = color?.darker()?.cgColor
        button.layer.borderWidth = 5
        button.backgroundColor = color
        button.isUserInteractionEnabled = false
//        circularViews.append(button)
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    func configureTreasureHuntCell(cell: UICollectionViewCell, hunt: TreasureHunt) {
        addIconToView(view: cell.contentView, name: "TreasureIcon")
        let name = UILabel(frame: CGRect.zero)
        cell.contentView.addSubview(name)
        name.text = hunt.name
        name.font = UIFont.boldSystemFont(ofSize: 30)
        name.adjustsFontSizeToFitWidth = true
        name.textColor = .lightGray
        name.backgroundColor = .white
        name.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            name.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            name.widthAnchor.constraint(lessThanOrEqualToConstant: 150)
        ])
    }
    
    // MARK: Other UI
    func updateCircleSizes() {
        makeViewsCircular(views: circularViews)
    }
}
