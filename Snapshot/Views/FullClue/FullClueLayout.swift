//
//  FullClueLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/9/21.
//

import Foundation
import UIKit

class FullClueLayout {
    // MARK: Properties
    
    // UI elements
//    private let titleLabel: UILabel
//    private let clueText: UILabel
    private let stackView: UIStackView
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(titleLabel: UILabel, clueText: UILabel, hintView: UIStackView?) {
//        self.titleLabel = titleLabel
//        self.clueText = clueText
        stackView = UIStackView()
        
        let titleRow = getRowForCenteredView(view: titleLabel)
        let textRow = getRowForCenteredView(view: clueText)

        doNotAutoResize(views: [stackView, titleLabel, clueText, titleRow, textRow])
        setLabelsToDefaults(labels: [titleLabel, clueText])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(titleRow)
        stackView.addArrangedSubview(textRow)
        if hintView != nil {
            stackView.addArrangedSubview(getRowForCenteredView(view: hintView!))
        }
        
        // Portrait
        portraitSizeMap = [
            stackView: (1, 0.85),
            titleLabel: (0.6, 0.15),
            clueText: (0.8, 0.25),
        ]
        
        portraitSpacingMap = [
            stackView: (0.5, 0.5),
        ]
        
        // Landscape
        landscapeSizeMap = [:
//            titleLabel: (, ),
//            clueText: (, ),
        ]
        
        landscapeSpacingMap = [:
//            titleLabel: (, ),
//            clueText: (, ),
        ]
        
        if hintView != nil {
            doNotAutoResize(view: hintView!)
            for subview in hintView!.arrangedSubviews as! [UIButton] {
                doNotAutoResize(view: subview)
                setButtonsToDefaults(buttons: [subview], withInsets: 5)
                portraitSizeMap[subview] = (0.2, 0.04)
            }
        }
    }
    
    // MARK: Constraints
    
    func configureConstraints(view: UIView)  {
        view.backgroundColor = globalBackgroundColor()
        view.addSubview(stackView)
        
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
