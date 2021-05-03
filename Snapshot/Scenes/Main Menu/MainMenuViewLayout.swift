//
//  MainMenuViewLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 2/28/21.
//

import Foundation
import UIKit

class MainMenuViewViewLayout {
    // MARK: Properties
    
    // UI elements
    private let titleLabel: UILabel
    private let stackView: UIStackView
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(titleLabel: UILabel, stackView: UIStackView) {
        self.titleLabel = titleLabel
        self.stackView = stackView

        doNotAutoResize(views: [titleLabel, stackView])
        setLabelsToDefaults(labels: [titleLabel])
        setButtonsToDefaults(buttons: [])
        
        // Portrait
        portraitSizeMap = [
            titleLabel: (1, 0.25),
            stackView: (1, 0.75),
        ]
        
        portraitSpacingMap = [
            titleLabel: (0.5, 0.125),
            stackView: (0.5, 0.625),
        ]
        
        // Landscape
        landscapeSizeMap = [
            titleLabel: (1, 0.3),
            stackView: (1, 0.7),
        ]
        
        landscapeSpacingMap = [
            titleLabel: (0.5, 0.15),
            stackView: (0.5, 0.65),
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
    func getRow(icon: String) -> UIView {
        let row = UIView()
        stackView.addArrangedSubview(row)
        portraitConstraints += [
            row.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ]
        landscapeConstraints += [
            row.heightAnchor.constraint(equalTo: stackView.heightAnchor),
        ]
        addIconToView(view: row, name: icon, tint: .white)
        return row
    }
}
