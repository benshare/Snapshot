//
//  EditClueViewLayout.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/4/21.
//

import Foundation
import UIKit
import MapKit

class EditClueViewLayout {
    // MARK: Properties
    
    // UI elements
    private let navigationBar: NavigationBarView
    private let scrollView: ScrollableStackView
    private let clueLocation: MKMapView
    private var textRow: UIView?
    private var locationRow: UIView?
    private let startingButtonAndLabel: ButtonAndLabel
    private let endingButtonAndLabel: ButtonAndLabel
    
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
    private var clueType: RowType
    
    init(navigationBar: NavigationBarView, scrollView: ScrollableStackView, clueLocation: MKMapView, clueText: UITextView, startingButtonAndLabel: ButtonAndLabel, endingButtonAndLabel: ButtonAndLabel, clueType: RowType = .clue) {
        self.navigationBar = navigationBar
        self.scrollView = scrollView
        self.clueLocation = clueLocation
        self.startingButtonAndLabel = startingButtonAndLabel
        self.endingButtonAndLabel = endingButtonAndLabel
        self.clueType = clueType

        doNotAutoResize(views: [navigationBar, scrollView, clueLocation, clueText, startingButtonAndLabel, endingButtonAndLabel])
        
        if clueType == .start {
            // Portrait
            portraitSizeMap = [
                navigationBar: (1, 0.2),
                clueLocation: (0.7, 0),
            ]
            scrollView.isHidden = true
            clueText.isHidden = true
            
            portraitSpacingMap = [
                navigationBar: (0.5, 0.1),
                clueLocation: (0.5, 0.6),
            ]
        } else {
            self.textRow = getRowForCenteredView(view: clueText)
            self.locationRow = getRowForCenteredView(view: clueLocation)
            
            clueText.layer.borderWidth = 2
            clueText.layer.borderColor = UIColor.lightGray.cgColor
            clueText.font = UIFont.systemFont(ofSize: 20)
            
            scrollView.addToStack(view: textRow!)
            scrollView.addToStack(view: locationRow!)
            scrollView.addBorders(width: 40, color: .white)
                
            // Portrait
            portraitSizeMap = [
                navigationBar: (1, 0.2),
                scrollView: (1, 0.7),
                clueText: (0.7, 0.3),
                clueLocation: (0.7, 0.3),
            ]
            
            portraitSpacingMap = [
                navigationBar: (0.5, 0.1),
                scrollView: (0.5, 0.65),
            ]
        }
        
        // Landscape
        landscapeSizeMap = [:
//            navigationBar: (, ),
//            clueLocation: (, ),
//            clueText: (, ),
//            isStartingButton: (, ),
//            addImageButton: (, ),
        ]
        
        landscapeSpacingMap = [:
//            navigationBar: (, ),
//            clueLocation: (, ),
//            clueText: (, ),
//            isStartingButton: (, ),
//            addImageButton: (, ),
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
    
    func showFullViewMap(view: UIView, delegate: EditClueViewController) {
        
        let fullMap = MKMapView()
        doNotAutoResize(view: fullMap)
        view.addSubview(fullMap)
        let newConstraints = getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: [fullMap: (1, 1)]) + getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: [fullMap: (0.5, 0.5)], parentView: view)
        NSLayoutConstraint.activate(newConstraints)
        
        fullMap.setRegion(clueLocation.region, animated: false)
        
        fullMap.addAnnotation(clueLocation.annotations[0])
        fullMap.delegate = delegate
        
        let checkButton = UIButton()
        doNotAutoResize(view: checkButton)
        fullMap.addSubview(checkButton)
        checkButton.setBackgroundImage(UIImage(named: "CheckmarkIcon"), for: .normal)
        checkButton.alpha = 0.7
        
        let buttonConstraints = getSizeConstraints(widthAnchor: fullMap.widthAnchor, heightAnchor: fullMap.heightAnchor, sizeMap: [checkButton: (0.1, 0)]) + getSpacingConstraints(leftAnchor: fullMap.leftAnchor, widthAnchor: fullMap.widthAnchor, topAnchor: fullMap.topAnchor, heightAnchor: fullMap.heightAnchor, spacingMap: [checkButton: (0.9, 0.08)], parentView: fullMap)
        NSLayoutConstraint.activate(buttonConstraints)
        
        checkButton.addAction {
            self.clueLocation.setCenter(fullMap.centerCoordinate, animated: false)
            fullMap.removeFromSuperview()
            if self.clueType == .clue {
                delegate.clue.location = fullMap.centerCoordinate
            } else {
                delegate.huntIfStart.startingLocation = fullMap.centerCoordinate
            }
            didUpdateActiveUser()
            self.clueLocation.addOneTimeTapEvent {
                self.showFullViewMap(view: view, delegate: delegate)
            }
        }
    }
    
    private func getRowForCenteredView(view: UIView) -> UIView {
        let row = UIView()
        doNotAutoResize(view: row)
        row.backgroundColor = .white
        row.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalTo: row.heightAnchor),
            view.centerXAnchor.constraint(equalTo: row.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: row.centerYAnchor),
        ])
        return row
    }
}

// MARK: Helper Classes
class ButtonAndLabel: UIView {
    let button: UIButton
    let label: UILabel
    
    required init?(coder: NSCoder) {
        self.button = UIButton()
        self.label = UILabel()
        
        super.init(coder: coder)
        
        doNotAutoResize(views: [button, label])
        setButtonsToDefaults(buttons: [button])
        setLabelsToDefaults(labels: [label])
        
        self.addSubview(button)
        self.addSubview(label)
        let sizeMap: [UIView : (CGFloat, CGFloat)] = [
            button: (0.2, 0),
            label: (0.7, 1),
        ]
        let spacingMap: [UIView : (CGFloat, CGFloat)] = [
            button: (0.1, 0.5),
            label: (0.6, 0.5),
        ]
        let constraints = getSizeConstraints(widthAnchor: self.widthAnchor, heightAnchor: self.heightAnchor, sizeMap: sizeMap) + getSpacingConstraints(leftAnchor: self.leftAnchor, widthAnchor: self.widthAnchor, topAnchor: self.topAnchor, heightAnchor: self.heightAnchor, spacingMap: spacingMap, parentView: self)
        NSLayoutConstraint.activate(constraints)
    }
}
