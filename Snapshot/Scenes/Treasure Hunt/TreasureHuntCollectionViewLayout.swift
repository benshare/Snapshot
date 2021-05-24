//
//  TreasureHuntCollectionViewLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/28/21.
//

import Foundation
import UIKit

class TreasureHuntCollectionViewViewLayout: UILayout {
    // MARK: Properties
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Other
    private var circularViews = [UIView]()
    private var headers = [UIView]()
    private var noSharedHuntsLabel = UILabel()
    
    init(navigationBar: NavigationBarView, headerView: ScrollableStackView, titleLabel: UILabel, collection: UICollectionView, sharedIsEmpty: Bool) {
        super.init()
        let sectionLabels = ["Your Hunts", "Shared Hunts"].map( {
                (title: String) -> UILabel in
                let label = UILabel()
                label.text = title
                return label
        } )
        doNotAutoResize(views: [navigationBar, headerView, titleLabel, collection, noSharedHuntsLabel] + sectionLabels)
        setLabelsToDefaults(labels: [titleLabel, noSharedHuntsLabel] + sectionLabels)
        
        titleLabel.isHidden = true
        
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            headerView: (1, 0.1),
            collection: (1, 0.7),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            headerView: (0.5, 0.25),
            collection: (0.5, 0.65),
        ]
        
        landscapeSizeMap = [
            navigationBar: (1, 0.25),
            headerView: (1, 0.15),
            collection: (1, 0.6),
        ]
        
        landscapeSpacingMap = [
            navigationBar: (0.5, 0.125),
            headerView: (0.5, 0.325),
            collection: (0.5, 0.7),
        ]
        
        for label in sectionLabels {
            label.font = UIFont.systemFont(ofSize: 20)
            let column = getColumnForCenteredView(view: label, withBuffer: 30)
            headerView.addToStack(view: column)
            headers.append(column)
            portraitConstraints.append(column.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.5))
            landscapeConstraints.append(column.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.5))
        }
        
        if sharedIsEmpty {
            collection.addSubview(noSharedHuntsLabel)
            noSharedHuntsLabel.text = "No shared hunts"
            noSharedHuntsLabel.font = UIFont.italicSystemFont(ofSize: 30)
            NSLayoutConstraint.activate([
                noSharedHuntsLabel.centerXAnchor.constraint(equalTo: collection.centerXAnchor),
                noSharedHuntsLabel.centerYAnchor.constraint(equalTo: collection.centerYAnchor),
                noSharedHuntsLabel.widthAnchor.constraint(equalTo: collection.widthAnchor, multiplier: 0.7),
            ])
        }
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
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    func configureTreasureHuntCell(cell: UICollectionViewCell, hunt: TreasureHunt) {
        addIconToView(view: cell.contentView, name: "TreasureIcon")
        let name = UILabel(frame: CGRect.zero)
        doNotAutoResize(view: name)
        setLabelsToDefaults(labels: [name])
        cell.contentView.addSubview(name)
        name.text = hunt.name
        name.font = UIFont.boldSystemFont(ofSize: 30)
        name.textColor = .lightGray
        name.backgroundColor = .white
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
    
    func selectSection(section: Int) {
        for ind in 0...headers.count - 1 {
            let cur = headers[ind]
            cur.removeBorders()
            if ind == section {
                cur.backgroundColor = .white
                cur.addBorders(sides: [.top])
            } else {
                cur.backgroundColor = .lightGray
                if ind == 0 {
                    cur.addBorders(sides: [.bottom, .right])
                } else if ind == headers.count - 1 {
                    cur.addBorders(sides: [.bottom, .left])
                } else {
                    cur.addBorders(sides: [.bottom, .left, .right])
                }
            }
        }
        if section == 0 {
            noSharedHuntsLabel.isHidden = true
        } else {
            noSharedHuntsLabel.isHidden = false
        }
    }
}
