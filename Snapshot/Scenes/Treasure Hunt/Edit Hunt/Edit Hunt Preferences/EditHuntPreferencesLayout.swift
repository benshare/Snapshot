//
//  EditHuntPreferencesLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/15/21.
//

import Foundation
import UIKit
import MapKit

class EditHuntPreferencesLayout {
    // MARK: Properties
    
    // UI elements
    private let navigationBar: NavigationBarView
    private let titleLabel: UILabel
    private let scrollView: ScrollableStackView
    private var styleRow = UIView()
    private var sensitivityRow = UIView()
    private let sensitivityPreview: MKMapView?
    private var designRow = UIView()
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(navigationBar: NavigationBarView, titleLabel: UILabel, scrollView: ScrollableStackView, styleLabel: UILabel, stylePicker: UIPickerView, sensitivityLabel: UILabel, sensitivityPicker: UIPickerView, sensitivityPreview: MKMapView?, designLabel: UILabel, designPicker: UIPickerView) {
        self.navigationBar = navigationBar
        self.titleLabel = titleLabel
        self.scrollView = scrollView
        self.sensitivityPreview = sensitivityPreview
        self.styleRow = getRowForLabelAndPicker(label: styleLabel, picker: stylePicker)
        self.sensitivityRow = getRowForLabelAndPicker(label: sensitivityLabel, picker: sensitivityPicker)
        self.designRow = getRowForLabelAndPicker(label: designLabel, picker: designPicker)
        
        let combinedSensitivityRow = UIView()
        combinedSensitivityRow.addSubview(sensitivityRow)
        if sensitivityPreview != nil {
            combinedSensitivityRow.addSubview(sensitivityPreview!)
        }
        combinedSensitivityRow.backgroundColor = .white
        
        if sensitivityPreview != nil {
            NSLayoutConstraint.activate([
                sensitivityRow.centerXAnchor.constraint(equalTo: combinedSensitivityRow.centerXAnchor),
                sensitivityRow.topAnchor.constraint(equalTo: combinedSensitivityRow.topAnchor),
                sensitivityPreview!.centerXAnchor.constraint(equalTo: combinedSensitivityRow.centerXAnchor),
                sensitivityPreview!.topAnchor.constraint(equalTo: sensitivityRow.bottomAnchor),
                sensitivityPreview!.bottomAnchor.constraint(equalTo: combinedSensitivityRow.bottomAnchor, constant: -10)
            ])
        } else {
            NSLayoutConstraint.activate([
                sensitivityRow.centerXAnchor.constraint(equalTo: combinedSensitivityRow.centerXAnchor),
                sensitivityRow.topAnchor.constraint(equalTo: combinedSensitivityRow.topAnchor),
                sensitivityRow.bottomAnchor.constraint(equalTo: combinedSensitivityRow.bottomAnchor),
            ])
        }
        
        doNotAutoResize(views: [navigationBar, titleLabel, scrollView, styleLabel, stylePicker, sensitivityLabel, sensitivityPicker, combinedSensitivityRow, designLabel, designPicker])
        if sensitivityPreview != nil {
            doNotAutoResize(view: sensitivityPreview!)
        }
        setLabelsToDefaults(labels: [titleLabel, styleLabel, sensitivityLabel, designLabel])
        setButtonsToDefaults(buttons: [])
        
        scrollView.addToStack(view: styleRow)
        scrollView.addToStack(view: combinedSensitivityRow)
        scrollView.addToStack(view: designRow)
        scrollView.addBorders()
        
        titleLabel.isHidden = true
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            scrollView: (1, 0.8),
            styleRow: (1, 0.3),
//            combinedSensitivityRow: (1, 0.5),
            sensitivityRow: (1, 0.3),
            designRow: (1, 0.3),
        ]
        if sensitivityPreview != nil {
            portraitSizeMap[sensitivityPreview!] = (0, 0.3)
            doNotAutoResize(view: sensitivityPreview!)
        }
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            scrollView: (0.5, 0.6),
        ]
        
        // Landscape
        landscapeSizeMap = [:
//            titleLabel: (, ),
//            scrollView: (, ),
//            styleLabel: (, ),
//            stylePicker: (, ),
//            sensitivityLabel: (, ),
//            sensitivityPicker: (, ),
//            sensitivityPreview: (, ),
//            designLabel: (, ),
//            designPicker: (, ),
        ]
        
        landscapeSpacingMap = [:
//            titleLabel: (, ),
//            scrollView: (, ),
//            styleLabel: (, ),
//            stylePicker: (, ),
//            sensitivityLabel: (, ),
//            sensitivityPicker: (, ),
//            sensitivityPreview: (, ),
//            designLabel: (, ),
//            designPicker: (, ),
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
    private func getRowForLabelAndPicker(label: UILabel, picker: UIPickerView) -> UIView {
        let row = UIView()
        doNotAutoResize(view: row)
        row.addSubview(label)
        row.addSubview(picker)
        row.backgroundColor = .white
        setLabelsToDefaults(labels: [label])
        
        let sizeMap: [UIView : (CGFloat, CGFloat)] = [
            label: (0.3, 0.2),
            picker: (0, 0.8),
        ]
        
        let spacingMap: [UIView : (CGFloat, CGFloat)] = [
            label: (0.2, 0.5),
            picker: (0.7, 0.5),
        ]
        let constraints = getSizeConstraints(widthAnchor: row.widthAnchor, heightAnchor: row.heightAnchor, sizeMap: sizeMap) + getSpacingConstraints(leftAnchor: row.leftAnchor, widthAnchor: row.widthAnchor, topAnchor: row.topAnchor, heightAnchor: row.heightAnchor, spacingMap: spacingMap, parentView: row)
        NSLayoutConstraint.activate(constraints)
        return row
    }
}
