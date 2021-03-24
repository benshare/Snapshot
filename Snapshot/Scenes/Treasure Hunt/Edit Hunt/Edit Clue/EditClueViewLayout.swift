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
    private let clueImage: UIImageView
    private var hintView: UIStackView!
    
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
    var clue: Clue!
    var fullImage: UIImageView!
    
    init(navigationBar: NavigationBarView, scrollView: ScrollableStackView, clueLocation: MKMapView, clueText: UITextView, clueImage: UIImageView, hintView: UIStackView, clueType: RowType = .clue) {
        self.navigationBar = navigationBar
        self.scrollView = scrollView
        self.clueLocation = clueLocation
        self.clueImage = clueImage
        self.clueType = clueType

        doNotAutoResize(views: [navigationBar, scrollView, clueLocation, clueText, clueImage, hintView])
        
        if clueType == .start {
            // Portrait
            portraitSizeMap = [
                navigationBar: (1, 0.2),
                clueLocation: (0.7, 0),
            ]
            scrollView.isHidden = true
            clueText.isHidden = true
            clueImage.isHidden = true
            hintView.isHidden = true
            
            portraitSpacingMap = [
                navigationBar: (0.5, 0.1),
                clueLocation: (0.5, 0.6),
            ]
        } else {
            self.hintView = hintView
            
            clueText.layer.borderWidth = 2
            clueText.layer.borderColor = UIColor.lightGray.cgColor
            clueText.font = UIFont.systemFont(ofSize: 20)
            
            scrollView.addToStack(view: getRowForCenteredView(view: clueLocation))
            scrollView.addToStack(view: getRowForCenteredView(view: clueText))
            scrollView.addToStack(view: getRowForCenteredView(view: clueImage))
            scrollView.addToStack(view: getRowForCenteredView(view: hintView))
            scrollView.addToStack(view: UIView(frame: CGRect.zero))
            
            scrollView.addBorders(width: 40, color: .white)
                
            // Portrait
            portraitSizeMap = [
                navigationBar: (1, 0.2),
                scrollView: (1, 0.7),
                clueLocation: (0.7, 0.3),
                clueText: (0.7, 0.3),
                clueImage: (0.7, 0.3),
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
        if hintView != nil {
            portraitConstraints.append(hintView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7))
        }
        
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
    
    // MARK: Hints
    func addHintRow(delegate: UITextFieldDelegate, hintText: String = "", initial: Bool = false) {
        let textField = UITextField()
        let deleteButton = UIButton()
        let row = UIView()
        doNotAutoResize(views: [textField, row, deleteButton])
        row.addSubview(textField)
        row.addSubview(deleteButton)
        let index = initial ? hintView.arrangedSubviews.count : hintView.arrangedSubviews.count - 1
        hintView.insertArrangedSubview(row, at: index)
        
        NSLayoutConstraint.activate(
            getSizeConstraints(widthAnchor: row.widthAnchor, heightAnchor: row.heightAnchor, sizeMap: [textField: (0.84, 0.5), deleteButton: (0, 0.3)]) +
            getSpacingConstraints(leftAnchor: row.leftAnchor, widthAnchor: row.widthAnchor, topAnchor: row.topAnchor, heightAnchor: row.heightAnchor, spacingMap: [textField: (0.42, 0.5), deleteButton: (0.95, 0.5)], parentView: row) +
                [row.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, multiplier: 0.12)]
        )
        
        textField.text =  hintText
        textField.delegate = delegate
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        
        deleteButton.setBackgroundImage(UIImage(named: "TrashIcon"), for: .normal)
        deleteButton.addAction {
            let index = self.hintView.arrangedSubviews.firstIndex(of: row)!
            self.hintView.removeArrangedSubview(row)
            row.removeFromSuperview()
            self.clue.hints.remove(at: index - 1)
            didUpdateActiveUser()
            if self.clue.hints.count == 2 {
                self.addPlusRow(delegate: delegate)
            }
        }
    }
    
    func addPlusRow(delegate: UITextFieldDelegate) {
        let addButton = UIButton()
        let addRow = UIView()
        doNotAutoResize(views: [addButton, addRow])
        addRow.addSubview(addButton)
        NSLayoutConstraint.activate(
            getSizeConstraints(widthAnchor: addRow.widthAnchor, heightAnchor: addRow.heightAnchor, sizeMap: [addButton: (0.1, 0)]) +
            getSpacingConstraints(leftAnchor: addRow.leftAnchor, widthAnchor: addRow.widthAnchor, topAnchor: addRow.topAnchor, heightAnchor: addRow.heightAnchor, spacingMap: [addButton: (0.5, 0.5)], parentView: addRow) +
            [addRow.heightAnchor.constraint(equalToConstant: 50)]
        )
        hintView.addArrangedSubview(addRow)
        
        setButtonsToDefaults(buttons: [addButton])
        addButton.setBackgroundImage(UIImage(named: "PlusIcon"), for: .normal)
        addButton.addAction {
            self.addHintRow(delegate: delegate)
            self.clue.addHint(hint: "")
            if self.clue.hints.count == 3 {
                self.hintView.removeArrangedSubview(addRow)
            }
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    // MARK: Map
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
                delegate.hunt.startingLocation = fullMap.centerCoordinate
            }
            didUpdateActiveUser()
            self.clueLocation.addOneTimeTapEvent {
                self.showFullViewMap(view: view, delegate: delegate)
            }
        }
    }
    
    // MARK: Image
    func showFullViewImage(view: UIView, cameraCallback: @escaping () -> Void, libraryCallback: @escaping () -> Void) {
        fullImage = UIImageView()
        doNotAutoResize(view: fullImage)
        view.addSubview(fullImage)
        
        let newConstraints = getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor, sizeMap: [fullImage: (1, 1)]) + getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: view.topAnchor, heightAnchor: view.heightAnchor, spacingMap: [fullImage: (0.5, 0.5)], parentView: view)
        NSLayoutConstraint.activate(newConstraints)
        
        fullImage.image = clueImage.image
        fullImage.contentMode = .scaleAspectFit
        fullImage.backgroundColor = .white
        
        fullImage.addOneTimeTapEvent {
            self.fullImage.removeFromSuperview()
        }
        fullImage.isUserInteractionEnabled = true
        
        let cameraButton = UIButton()
        doNotAutoResize(view: cameraButton)
        fullImage.addSubview(cameraButton)
        cameraButton.setBackgroundImage(UIImage(named: "CameraIcon"), for: .normal)
        cameraButton.alpha = 0.7
        
        let deleteButton = UIButton()
        doNotAutoResize(view: deleteButton)
        fullImage.addSubview(deleteButton)
        deleteButton.setBackgroundImage(UIImage(named: "TrashIcon"), for: .normal)
        deleteButton.alpha = 0.7
        
        let libraryButton = UIButton()
        doNotAutoResize(view: libraryButton)
        fullImage.addSubview(libraryButton)
        libraryButton.setBackgroundImage(UIImage(named: "LibraryIcon"), for: .normal)
        libraryButton.alpha = 0.7
        
        let buttonConstraints =
            getSizeConstraints(widthAnchor: fullImage.widthAnchor, heightAnchor: fullImage.heightAnchor, sizeMap: [cameraButton: (0.1, 0), deleteButton: (0.1, 0), libraryButton: (0.1, 0)]) +
            getSpacingConstraints(leftAnchor: fullImage.leftAnchor, widthAnchor: fullImage.widthAnchor, topAnchor: fullImage.topAnchor, heightAnchor: fullImage.heightAnchor, spacingMap: [cameraButton: (0.1, 0.08), deleteButton: (0.5, 0.08), libraryButton: (0.9, 0.08)], parentView: fullImage)
        NSLayoutConstraint.activate(buttonConstraints)
        
        cameraButton.addAction(cameraCallback)
        deleteButton.addAction {
            let defaultImage = UIImage(named: "ClickToAdd")
            self.clueImage.image = defaultImage
            self.fullImage.image = defaultImage
            self.clue.image = nil
            didUpdateActiveUser()
        }
        libraryButton.addAction(libraryCallback)
    }
}
