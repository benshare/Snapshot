//
//  SegmentedTextLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 5/8/21.
//

import Foundation
import UIKit

class SegmentedTextLayout: UILayout {
    // MARK: Properties
    // UI elements
    
    // Constraint maps
    private var sizeMap: [UIView: (CGFloat, CGFloat)]!
    private var spacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // MARK: Initialization
    init(controllerField: UITextField, segmentedFields: [UITextField], spacingRatio: Double) {
        doNotAutoResize(views: [controllerField] + segmentedFields)
        
        let length = segmentedFields.count
        let totalWidth = CGFloat(Double(length) + spacingRatio * (Double(length) - 1))
        
        sizeMap = [
            controllerField: (1, 1),
        ]
        for field in segmentedFields {
            sizeMap[field] = (1 / totalWidth, 1)
        }
        
        spacingMap = [
            controllerField: (0.5, 0.5),
        ]
        for ind in 0...length - 1 {
            let field = segmentedFields[ind]
            let numerator = (1 + spacingRatio) * Double(ind) + 0.5
            let centerX = CGFloat(numerator) / totalWidth
            spacingMap[field] = (centerX, 0.5)
        }
        
        controllerField.isHidden = false
    }
    
    init(controllerField: UITextField, segmentedFields: [UITextField], segmentPattern: String, widthsAtIndices: [Double], parentView: SegmentedTextField, spacingRatio: Double) {
        doNotAutoResize(views: [controllerField] + segmentedFields)
        
        let length = segmentPattern.count
        let totalWidth = widthsAtIndices.last!
        
        sizeMap = [
            controllerField: (1, 1),
        ]
        
        spacingMap = [
            controllerField: (0.5, 0.5),
        ]
        
        var fieldIndex = 0
        for index in 0...length - 1 {
            let char = segmentPattern[index]
            if char == "_" {
                sizeMap[segmentedFields[fieldIndex]] = (1 / CGFloat(totalWidth), 1)
                spacingMap[segmentedFields[fieldIndex]] = (CGFloat((widthsAtIndices[index] + 0.5) / totalWidth), 0.5)
                fieldIndex += 1
            } else {
                let label = UILabel()
                doNotAutoResize(view: label)
                setLabelsToDefaults(labels: [label])
                parentView.addSubview(label)
                label.text = String(char)
                sizeMap[label] = (CGFloat(spacingRatio) / CGFloat(totalWidth), CGFloat(spacingRatio))
                spacingMap[label] = (CGFloat((widthsAtIndices[index] + 0.5 * spacingRatio) / totalWidth), 0.5)
            }
        }
    }
    
    func configure(view: UIView) {
        portraitConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: sizeMap)
        portraitConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: spacingMap, parentView: view)
        NSLayoutConstraint.activate(portraitConstraints)
    }
}
