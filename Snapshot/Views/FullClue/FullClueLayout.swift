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
    private let stackView: UIStackView
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(titleLabel: UILabel, clueText: UILabel, clueImage: UIImageView?, hintView: UIStackView?) {
        stackView = UIStackView()

        doNotAutoResize(views: [stackView, titleLabel, clueText])
        setLabelsToDefaults(labels: [titleLabel, clueText])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        
        let totalContentHeight: CGFloat = 0.7
        let titleUnits = 2
        let textUnits = 6
        let imageUnits = 6
        let hintUnits = 3
        var heightUnits = 0
        
        stackView.addArrangedSubview(getRowForCenteredView(view: titleLabel))
        heightUnits += titleUnits
        stackView.addArrangedSubview(getRowForCenteredView(view: clueText))
        heightUnits += textUnits
        if clueImage != nil {
            stackView.addArrangedSubview(getRowForCenteredView(view: clueImage!))
            heightUnits += imageUnits
        }
        if hintView != nil {
            stackView.addArrangedSubview(getRowForCenteredView(view: hintView!))
            heightUnits += hintUnits
        }
        
        let titleHeight = CGFloat(titleUnits) * totalContentHeight / CGFloat(heightUnits)
        let clueHeight = CGFloat(textUnits) * totalContentHeight / CGFloat(heightUnits)
        let imageHeight = CGFloat(imageUnits) * totalContentHeight / CGFloat(heightUnits)
        let hintHeight = CGFloat(hintUnits) * totalContentHeight / CGFloat(heightUnits)
        
        // Portrait
        portraitSizeMap = [
            stackView: (1, 0.85),
            titleLabel: (CGFloat(0.6), titleHeight),
            clueText: (CGFloat(0.8), clueHeight),
        ]
        
        portraitSpacingMap = [
            stackView: (0.5, 0.5),
        ]
        
        // Landscape
        landscapeSizeMap = [:
        ]
        
        landscapeSpacingMap = [:
        ]
        
        if clueImage != nil {
            doNotAutoResize(view: clueImage!)
            portraitSizeMap[clueImage!] = (0.6, imageHeight)
        }
        
        if hintView != nil {
            doNotAutoResize(view: hintView!)
            let numRows = hintView!.arrangedSubviews.count
            for wrapper in hintView!.arrangedSubviews {
                let button = wrapper.subviews[0] as! UIButton
                doNotAutoResize(views: [wrapper, button])
                setButtonsToDefaults(buttons: [button], withInsets: 5)
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalTo: wrapper.widthAnchor, multiplier: 0.8),
                    button.heightAnchor.constraint(equalTo: wrapper.heightAnchor, multiplier: 0.8),
                    button.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
                    button.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor),
                ])
                portraitSizeMap[wrapper] = (0.2, hintHeight / CGFloat(numRows))
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
