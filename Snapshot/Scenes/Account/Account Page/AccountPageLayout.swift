//
//  AccountPageLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 4/4/21.
//

import Foundation
import UIKit

class AccountPageLayout: UILayout {
    // MARK: Properties
    
    // UI elements
    private let navigationBar: NavigationBarView
    private let scrollView: ScrollableStackView
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // MARK: Initialization
    init(navigationBar: NavigationBarView, scrollView: ScrollableStackView) {
        self.navigationBar = navigationBar
        self.scrollView = scrollView
        
        super.init()
        
        let comingSoonLabel = UILabel()

        doNotAutoResize(views: [navigationBar, scrollView, comingSoonLabel])
        setLabelsToDefaults(labels: [comingSoonLabel])
        setButtonsToDefaults(buttons: [])
        
        comingSoonLabel.text = "More info coming soon!"
        comingSoonLabel.textColor = .black
        
        let labelWrapper = getWrapperForView(view: comingSoonLabel)
        scrollView.addToStack(view: labelWrapper)
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            scrollView: (1, 0.8),
            comingSoonLabel: (0.6, 0.8),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            scrollView: (0.5, 0.6),
        ]
        
        // Landscape
        landscapeSizeMap = [
            navigationBar: (1, 0.3),
            scrollView: (1, 0.7),
            comingSoonLabel: (1, 0.3),
        ]
        
        landscapeSpacingMap = [
            navigationBar: (0.5, 0.15),
            scrollView: (0.5, 0.65),
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
            scrollView.setAxis(axis: .vertical)
            NSLayoutConstraint.activate(portraitConstraints)
        } else {
            NSLayoutConstraint.deactivate(portraitConstraints)
            scrollView.setAxis(axis: .horizontal)
            NSLayoutConstraint.activate(landscapeConstraints)
        }
    }
    
    // MARK: Other UI
}
