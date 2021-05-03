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
    
    // Constraint maps
    private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
    private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
    
    // Constraints
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    init(navigationBar: NavigationBarView, titleLabel: UILabel, scrollView: ScrollableStackView, styleLabel: UILabel, stylePicker: UIPickerView, hintsView: UIView, sensitivityLabel: UILabel, sensitivityPicker: UIPickerView, sensitivityPreview: MKMapView?, designLabel: UILabel, designPicker: UIPickerView) {
        
        // Style view
        let styleContent = getRowForLabelAndPicker(label: styleLabel, picker: stylePicker)
        let styleView = getResizableRowForView(view: styleContent)
        
        // Hints view
        let hintsView = getResizableRowForView(view: hintsView)
        
        // Sensitivity view
        let sensitivityView: UIView
        let sensitivityFirstRow = getRowForLabelAndPicker(label: sensitivityLabel, picker: sensitivityPicker)
        
        if sensitivityPreview == nil {
            sensitivityView = getResizableRowForView(view: sensitivityFirstRow)
        } else {
            let combinedSentivityView = UIView()
            doNotAutoResize(view: combinedSentivityView)
            combinedSentivityView.addSubview(sensitivityFirstRow)
            combinedSentivityView.addSubview(sensitivityPreview!)
            portraitConstraints += [
                sensitivityFirstRow.widthAnchor.constraint(equalTo: combinedSentivityView.widthAnchor),
                sensitivityFirstRow.centerXAnchor.constraint(equalTo: combinedSentivityView.centerXAnchor),
                sensitivityFirstRow.topAnchor.constraint(equalTo: combinedSentivityView.topAnchor),
                sensitivityPreview!.centerXAnchor.constraint(equalTo: combinedSentivityView.centerXAnchor),
                sensitivityPreview!.topAnchor.constraint(equalTo: sensitivityFirstRow.bottomAnchor),
                sensitivityPreview!.bottomAnchor.constraint(equalTo: combinedSentivityView.bottomAnchor, constant: -10),
                sensitivityPreview!.heightAnchor.constraint(equalTo: sensitivityFirstRow.heightAnchor),
                sensitivityPreview!.heightAnchor.constraint(equalTo: sensitivityPreview!.widthAnchor),
            ]
            
            landscapeConstraints += [
                sensitivityFirstRow.heightAnchor.constraint(equalTo: combinedSentivityView.heightAnchor, multiplier: 0.7),
                sensitivityFirstRow.centerYAnchor.constraint(equalTo: combinedSentivityView.centerYAnchor),
                sensitivityFirstRow.leftAnchor.constraint(equalTo: combinedSentivityView.leftAnchor),
                sensitivityPreview!.centerYAnchor.constraint(equalTo: combinedSentivityView.centerYAnchor),
                sensitivityPreview!.leftAnchor.constraint(equalTo: sensitivityFirstRow.rightAnchor, constant: 20),
                sensitivityPreview!.rightAnchor.constraint(equalTo: combinedSentivityView.rightAnchor, constant: -20),
                sensitivityPreview!.heightAnchor.constraint(equalTo: combinedSentivityView.heightAnchor, multiplier: 0.6),
                sensitivityPreview!.heightAnchor.constraint(equalTo: sensitivityPreview!.widthAnchor),
            ]
            sensitivityView = getResizableRowForView(view: combinedSentivityView, portraitRatio: 1, landscapeRatio: 2)
        }

        // Design view
        let designContent = getRowForLabelAndPicker(label: designLabel, picker: designPicker)
        let designView = getResizableRowForView(view: designContent)

        doNotAutoResize(views: [navigationBar, titleLabel, scrollView, styleLabel, stylePicker, sensitivityLabel, sensitivityPicker, designLabel, designPicker])
        if sensitivityPreview != nil {
            doNotAutoResize(view: sensitivityPreview!)
        }
        setLabelsToDefaults(labels: [titleLabel, styleLabel, sensitivityLabel, designLabel])

        scrollView.addToStack(view: styleView)
        scrollView.addToStack(view: hintsView)
        scrollView.addToStack(view: sensitivityView)
        scrollView.addToStack(view: designView)
        scrollView.addBorders(color: SCENE_COLORS[.hunts]!)
        
        titleLabel.isHidden = true
        
        // Portrait
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            scrollView: (1, 0.8),
        ]
        
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            scrollView: (0.5, 0.6),
        ]
        
        // Landscape
        landscapeSizeMap = [
            navigationBar: (1, 0.3),
            scrollView: (1, 0.7),
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
        
        let sizeMap: [UIView : (CGFloat, CGFloat)] = [
            label: (0.3, 0.2),
            picker: (0, 0.8),
        ]
        
        let spacingMap: [UIView : (CGFloat, CGFloat)] = [
            label: (0.2, 0.5),
            picker: (0.7, 0.5),
        ]
        NSLayoutConstraint.activate(
            getSizeConstraints(widthAnchor: row.widthAnchor, heightAnchor: row.heightAnchor, sizeMap: sizeMap) +
            getSpacingConstraints(leftAnchor: row.leftAnchor, widthAnchor: row.widthAnchor, topAnchor: row.topAnchor, heightAnchor: row.heightAnchor, spacingMap: spacingMap, parentView: row))
        return row
    }
    
    func getResizableRowForView(view: UIView, portraitRatio: CGFloat = 2, landscapeRatio: CGFloat = 1.5) -> UIView {
        let row = UIView()
        doNotAutoResize(views: [row])
        row.addSubview(view)
        row.backgroundColor = .white
        
        portraitConstraints.append(row.widthAnchor.constraint(equalTo: row.heightAnchor, multiplier: portraitRatio))
        portraitConstraints += getSizeConstraints(widthAnchor: row.widthAnchor, heightAnchor: row.heightAnchor, sizeMap: [view: (0.9, 0.9)])
        portraitConstraints += getSpacingConstraints(leftAnchor: row.leftAnchor, widthAnchor: row.widthAnchor, topAnchor: row.topAnchor, heightAnchor: row.heightAnchor, spacingMap: [view: (0.5, 0.5)], parentView: row)
        
        landscapeConstraints.append(row.widthAnchor.constraint(equalTo: row.heightAnchor, multiplier: landscapeRatio))
        landscapeConstraints += getSizeConstraints(widthAnchor: row.widthAnchor, heightAnchor: row.heightAnchor, sizeMap: [view: (0.9, 0.9)])
        landscapeConstraints += getSpacingConstraints(leftAnchor: row.leftAnchor, widthAnchor: row.widthAnchor, topAnchor: row.topAnchor, heightAnchor: row.heightAnchor, spacingMap: [view: (0.5, 0.5)], parentView: row)
        
        return row
    }
}
