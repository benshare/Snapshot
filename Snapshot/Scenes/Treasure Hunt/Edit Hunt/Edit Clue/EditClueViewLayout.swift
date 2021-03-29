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
        self.hintView = hintView

        doNotAutoResize(views: [navigationBar, scrollView, clueLocation, clueText, clueImage, hintView])
        
        portraitSizeMap = [
            navigationBar: (1, 0.2),
            scrollView: (1, 0.8),
        ]
        portraitSpacingMap = [
            navigationBar: (0.5, 0.1),
            scrollView: (0.5, 0.6),
        ]
        
        landscapeSizeMap = [
            navigationBar: (1, 0.3),
            scrollView: (1, 0.7),
        ]
        
        landscapeSpacingMap = [
            navigationBar: (0.5, 0.15),
            scrollView: (0.5, 0.65),
        ]
        
        if clueType == .start {
            let wrapper = UIView()
            doNotAutoResize(view: wrapper)
            wrapper.addSubview(clueLocation)
            
            NSLayoutConstraint.activate([
                clueLocation.widthAnchor.constraint(equalTo: clueLocation.heightAnchor),
                clueLocation.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
                clueLocation.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor),
            ])
            
            portraitConstraints.append(contentsOf: [
                clueLocation.widthAnchor.constraint(equalTo: wrapper.widthAnchor, multiplier: 0.8),
                wrapper.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            ])
            landscapeConstraints.append(contentsOf: [
                clueLocation.heightAnchor.constraint(equalTo: wrapper.heightAnchor, multiplier: 0.8),
                wrapper.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            ])
            
            scrollView.addToStack(view: wrapper)
            
            clueText.isHidden = true
            clueImage.isHidden = true
            hintView.isHidden = true
        } else {
            // Location
            scrollView.addToStack(view: getResizableRowForView(view: clueLocation))
            
            // Text
            clueText.layer.borderWidth = 2
            clueText.layer.borderColor = UIColor.lightGray.cgColor
            clueText.font = UIFont.systemFont(ofSize: 20)
            
            scrollView.addToStack(view: getResizableRowForView(view: clueText))
            
            // Image
            scrollView.addToStack(view: getResizableRowForView(view: clueImage))
            
            // Hint
            let wrapper = UIView()
            doNotAutoResize(view: wrapper)
            wrapper.addSubview(hintView)
            NSLayoutConstraint.activate([
                hintView.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor),
                hintView.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor),
            ])
            portraitConstraints += [
                wrapper.heightAnchor.constraint(equalTo: hintView.heightAnchor),
                hintView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            ]
            landscapeConstraints += [
                wrapper.widthAnchor.constraint(equalTo: hintView.widthAnchor),
                wrapper.widthAnchor.constraint(equalTo: wrapper.heightAnchor, multiplier: 1.5)
            ]
            scrollView.addToStack(view: wrapper)
            
            // Add a buffer at the bottom
            scrollView.addToStack(view: UIView(frame: CGRect.zero))
            scrollView.addBorders(width: 40, color: .white)
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
    
    // MARK: Other UI
    func updateCircleSizes() {
        makeViewsCircular(views: circularViews)
    }
    
    func getResizableRowForView(view: UIView, portraitRatio: CGFloat = 1.5, landscapeRatio: CGFloat = 1.5) -> UIView {
        let row = UIView()
        doNotAutoResize(view: row)
        row.addSubview(view)
        row.backgroundColor = .white
        
        portraitConstraints.append(row.widthAnchor.constraint(equalTo: row.heightAnchor, multiplier: portraitRatio))
        portraitConstraints += getSizeConstraints(widthAnchor: row.widthAnchor, heightAnchor: row.heightAnchor, sizeMap: [view: (0.8, 0.8)])
        portraitConstraints += getSpacingConstraints(leftAnchor: row.leftAnchor, widthAnchor: row.widthAnchor, topAnchor: row.topAnchor, heightAnchor: row.heightAnchor, spacingMap: [view: (0.5, 0.5)], parentView: row)
        
        landscapeConstraints.append(row.widthAnchor.constraint(equalTo: row.heightAnchor, multiplier: landscapeRatio))
        landscapeConstraints += getSizeConstraints(widthAnchor: row.widthAnchor, heightAnchor: row.heightAnchor, sizeMap: [view: (0.8, 0.8)])
        landscapeConstraints += getSpacingConstraints(leftAnchor: row.leftAnchor, widthAnchor: row.widthAnchor, topAnchor: row.topAnchor, heightAnchor: row.heightAnchor, spacingMap: [view: (0.5, 0.5)], parentView: row)
        
        return row
    }
    
    // MARK: Hints
    func addHintLabelRow() {
        let label = UILabel()
        let labelRow = UIView()
        doNotAutoResize(views: [label, labelRow])
        labelRow.addSubview(label)
        hintView.addArrangedSubview(labelRow)
        
        NSLayoutConstraint.activate(
            getSizeConstraints(widthAnchor: labelRow.widthAnchor, heightAnchor: labelRow.heightAnchor, sizeMap: [label: (0.2, 1)]) +
            getSpacingConstraints(leftAnchor: labelRow.leftAnchor, widthAnchor: labelRow.widthAnchor, topAnchor: labelRow.topAnchor, heightAnchor: labelRow.heightAnchor, spacingMap: [label: (0.1, 0.5)], parentView: labelRow)
        )
        portraitConstraints.append(labelRow.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.05))
        landscapeConstraints.append(labelRow.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.08))
        
        setLabelsToDefaults(labels: [label])
        label.text = "Hints:"
        label.textAlignment = .left
    }
    
    func addHintRow(delegate: UITextFieldDelegate, hintText: String = "", initial: Bool = false) {
        let row = UIView()
        let textField = UITextField()
        let deleteButton = UIButton()
        doNotAutoResize(views: [row, textField, deleteButton])
        row.addSubview(textField)
        row.addSubview(deleteButton)
        let index = initial ? hintView.arrangedSubviews.count : hintView.arrangedSubviews.count - 1
        hintView.insertArrangedSubview(row, at: index)
        
        NSLayoutConstraint.activate(
            getSizeConstraints(widthAnchor: row.widthAnchor, heightAnchor: row.heightAnchor, sizeMap: [textField: (0.84, 0.5), deleteButton: (0, 0.3)]) +
            getSpacingConstraints(leftAnchor: row.leftAnchor, widthAnchor: row.widthAnchor, topAnchor: row.topAnchor, heightAnchor: row.heightAnchor, spacingMap: [textField: (0.42, 0.5), deleteButton: (0.95, 0.5)], parentView: row)
        )
        portraitConstraints.append(row.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.15))
        landscapeConstraints.append(row.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.25))
        
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
            print("adding plus")
            if self.clue.hints.count == 2 {
                self.addPlusRow(delegate: delegate)
            }
            print("added plus")
        }
    }
    
    func addPlusRow(delegate: UITextFieldDelegate) {
        let addButton = UIButton()
        let addRow = UIView()
        doNotAutoResize(views: [addButton, addRow])
        addRow.addSubview(addButton)
        hintView.addArrangedSubview(addRow)
        NSLayoutConstraint.activate(
            getSizeConstraints(widthAnchor: addRow.widthAnchor, heightAnchor: addRow.heightAnchor, sizeMap: [addButton: (0.1, 0)]) +
            getSpacingConstraints(leftAnchor: addRow.leftAnchor, widthAnchor: addRow.widthAnchor, topAnchor: addRow.topAnchor, heightAnchor: addRow.heightAnchor, spacingMap: [addButton: (0.5, 0.5)], parentView: addRow)
        )
        portraitConstraints.append(addRow.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.05))
        landscapeConstraints.append(addRow.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.1))
        
        setButtonsToDefaults(buttons: [addButton])
        addButton.setBackgroundImage(UIImage(named: "PlusIcon"), for: .normal)
        addButton.addAction {
            self.addHintRow(delegate: delegate)
            self.clue.addHint(hint: "")
            if self.clue.hints.count == 3 {
                self.hintView.removeArrangedSubview(addRow)
            }
            if orientationIsPortrait() {
                let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom)
                self.scrollView.setContentOffset(bottomOffset, animated: true)
            }
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
    func showFullViewImage(view: UIView, cameraCallback: @escaping () -> Void, collectionCallback: @escaping () -> Void, libraryCallback: @escaping () -> Void) {
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
        
        let collectionButton = UIButton()
        doNotAutoResize(view: collectionButton)
        fullImage.addSubview(collectionButton)
        collectionButton.setBackgroundImage(UIImage(named: "SnapshotIcon"), for: .normal)
        collectionButton.alpha = 0.7
        
        let libraryButton = UIButton()
        doNotAutoResize(view: libraryButton)
        fullImage.addSubview(libraryButton)
        libraryButton.setBackgroundImage(UIImage(named: "LibraryIcon"), for: .normal)
        libraryButton.alpha = 0.7
        
        let deleteButton = UIButton()
        doNotAutoResize(view: deleteButton)
        fullImage.addSubview(deleteButton)
        deleteButton.setBackgroundImage(UIImage(named: "TrashIcon"), for: .normal)
        deleteButton.alpha = 0.7
        
        let buttonConstraints =
            getSizeConstraints(widthAnchor: fullImage.widthAnchor, heightAnchor: fullImage.heightAnchor, sizeMap: [cameraButton: (0.1, 0), collectionButton: (0.1, 0), libraryButton: (0.1, 0), deleteButton: (0.1, 0)]) +
            getSpacingConstraints(leftAnchor: fullImage.leftAnchor, widthAnchor: fullImage.widthAnchor, topAnchor: fullImage.topAnchor, heightAnchor: fullImage.heightAnchor, spacingMap: [cameraButton: (0.1, 0.08), collectionButton: (0.5, 0.08), libraryButton: (0.9, 0.08), deleteButton: (0.5, 0.92)], parentView: fullImage)
        NSLayoutConstraint.activate(buttonConstraints)
        
        cameraButton.addAction(cameraCallback)
        collectionButton.addAction(collectionCallback)
        libraryButton.addAction(libraryCallback)
        deleteButton.addAction {
            let defaultImage = UIImage(named: "ClickToAdd")
            self.clueImage.image = defaultImage
            self.fullImage.image = defaultImage
            self.clue.image = nil
            didUpdateActiveUser()
        }
    }
}
