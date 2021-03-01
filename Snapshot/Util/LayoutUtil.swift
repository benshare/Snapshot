//
//  LayoutUtil.swift
//  Missing Link
//
//  Created by Benjamin Share on 7/20/20.
//  Copyright © 2020 Benjamin Share. All rights reserved.
//

import Foundation
import UIKit

// MARK: Size
func getSizeConstraints(widthAnchor: NSLayoutDimension, heightAnchor: NSLayoutDimension, sizeMap: [UIView: (CGFloat, CGFloat)]) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    for element in sizeMap {
        let view = element.key
        let size = element.value
        // Assumption that only one value is 0
        if size.0 == 0 {
            constraints.append(getSquareConstraint(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor))
        } else {
            constraints.append(getWidthConstraint(view: view, widthAnchor: widthAnchor, multiple: size.0))
        }
        if size.1 == 0 {
            constraints.append(getSquareConstraint(widthAnchor: view.widthAnchor, heightAnchor: view.heightAnchor))
        } else {
            constraints.append(getHeightConstraint(view: view, heightAnchor: heightAnchor, multiple: size.1))
        }
    }
    return constraints
}

private func getWidthConstraint(view: UIView, widthAnchor: NSLayoutDimension, multiple: CGFloat) -> NSLayoutConstraint {
    return view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: multiple)
}

private func getHeightConstraint(view: UIView, heightAnchor: NSLayoutDimension, multiple: CGFloat) -> NSLayoutConstraint {
    return view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: multiple)
}

private func getSquareConstraint(widthAnchor: NSLayoutDimension, heightAnchor: NSLayoutDimension) -> NSLayoutConstraint {
    return widthAnchor.constraint(equalTo: heightAnchor)
}

// MARK: Spacing
func getSpacingConstraints(leftAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, widthAnchor: NSLayoutDimension, topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, heightAnchor: NSLayoutDimension, spacingMap: [UIView: (CGFloat, CGFloat)], parentView: UIView) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    for element in spacingMap {
        let view = element.key
        let spacing = element.value
        constraints += getHorizontalSpacingConstraintSet(view: view, leftAnchor: leftAnchor, widthAnchor: widthAnchor, center: spacing.0, parentView: parentView)
        constraints += getVerticalSpacingConstraintSet(view: view, topAnchor: topAnchor, heightAnchor: heightAnchor, center: spacing.1, parentView: parentView)
    }
    return constraints
}

private func getHorizontalSpacingConstraintSet(view: UIView, leftAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, widthAnchor: NSLayoutDimension, center: CGFloat, parentView: UIView) -> [NSLayoutConstraint] {
    let leftBuffer = UIView()
    leftBuffer.translatesAutoresizingMaskIntoConstraints = false
    parentView.addSubview(leftBuffer)
    
    return [
        leftBuffer.leftAnchor.constraint(equalTo: leftAnchor),
        leftBuffer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: center),
        leftBuffer.rightAnchor.constraint(equalTo: view.centerXAnchor),
    ]
}

private func getVerticalSpacingConstraintSet(view: UIView, topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, heightAnchor: NSLayoutDimension, center: CGFloat, parentView: UIView) -> [NSLayoutConstraint] {
    let topBuffer = UIView()
    topBuffer.translatesAutoresizingMaskIntoConstraints = false
    parentView.addSubview(topBuffer)
    
    return [
        topBuffer.topAnchor.constraint(equalTo: topAnchor),
        topBuffer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: center),
        topBuffer.bottomAnchor.constraint(equalTo: view.centerYAnchor),
    ]
}

// MARK: Defaults
func doNotAutoResize(views: [UIView]) {
    for view in views {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}

func setTextToDefaults(labels: [UILabel?]) {
    centerAlignText(labels: labels)
    setTextToResize(labels: labels)
}

func setButtonsToDefaults(buttons: [UIButton?], resize: Bool=true, withInsets: Int=0, withImageInsets: Int=0) {
    centerAlignText(labels: buttons.map( { $0?.titleLabel }))
    if resize {
        setTextToResize(labels: buttons.map( { $0?.titleLabel }))
    }
    if withInsets > 0 {
        setInsets(buttons: buttons, inset: CGFloat(withInsets))
    }
    if withImageInsets > 0 {
        setImageInsets(buttons: buttons, inset: CGFloat(withImageInsets))
    }
}

func centerAlignText(labels: [UILabel?]) {
    for label in labels {
        label?.textAlignment = .center
    }
}

private func setTextToResize(labels: [UILabel?]) {
    for label in labels {
        label?.font = label?.font.withSize(60)
        label?.adjustsFontSizeToFitWidth = true
        label?.baselineAdjustment = .alignCenters
    }
}

private func setInsets(buttons: [UIButton?], inset: CGFloat) {
    for button in buttons {
        button?.contentEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}

private func setImageInsets(buttons: [UIButton?], inset: CGFloat) {
    for button in buttons {
        button?.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        button?.imageView?.contentMode = .scaleAspectFit
    }
}

func makeViewCircular(view: UIView) {
    view.layer.cornerRadius = view.frame.height / 2.0
}

func makeViewsCircular(views: [UIView]) {
    for view in views {
        view.layer.cornerRadius = view.frame.height / 2.0
    }
}

extension UIView {
    func addOverlappingToParent(parent: UIView) {
        parent.addSubview(self)
        self.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
    }
}

// Debugging only
private func setTextBackgroundToRed(labels: [UILabel?]) {
    for label in labels {
        label?.backgroundColor = .red
    }
}

// MARK: Borders
func addBorders(view: UIView, top: Bool=false, bottom: Bool=false, left: Bool=false, right: Bool=false, width: CGFloat=2) -> [UIView] {
    var borders = [UIView]()
    if top {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        border.heightAnchor.constraint(equalToConstant: width).isActive = true
        border.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        border.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        border.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        border.backgroundColor = .black
        borders.append(border)
    }
    if bottom {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        border.heightAnchor.constraint(equalToConstant: width).isActive = true
        border.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        border.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        border.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        border.backgroundColor = .black
        borders.append(border)
    }
    if left {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        border.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        border.widthAnchor.constraint(equalToConstant: width).isActive = true
        border.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        border.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        border.backgroundColor = .black
        borders.append(border)
    }
    if right {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        border.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        border.widthAnchor.constraint(equalToConstant: width).isActive = true
        border.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        border.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        border.backgroundColor = .black
        borders.append(border)
    }
    return borders
}

// MARK: UIImage
func addFrame(imageView: UIView, color: UIColor = .brown) {
    imageView.layer.cornerRadius = 5
    imageView.layer.borderWidth = 5
    imageView.layer.masksToBounds = true
    imageView.layer.borderColor = color.cgColor
}

func addIconToView(view: UIView, name: String) {
    let imageView = UIImageView()
    view.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    imageView.image = UIImage(named: name)?.withAlignmentRectInsets(UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20))
    imageView.contentMode = .scaleAspectFit
}

// MARK: Blur
func blurView(view: UIView) -> UIVisualEffectView {
    let blurEffect = UIBlurEffect(style: .dark)
    let blurredEffectView = UIVisualEffectView(effect: blurEffect)
    blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(blurredEffectView)
    blurredEffectView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    blurredEffectView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    blurredEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    blurredEffectView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    return blurredEffectView
}

// MARK: Orientation
func orientationIsPortrait() -> Bool {
    if UIDevice.current.orientation.isFlat {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    return UIDevice.current.orientation.isPortrait || UIDevice.current.orientation.isFlat
}

// MARK: New Layouts
func generateNewLayout(name: String, elements: [(String, String)]) {
    print("""
    import UIKit

    class \(name)ViewLayout {
        // MARK: Properties
        
        // UI elements
    \(elements.map( { "\tprivate let \($0.0): \($0.1)" } ).joined(separator: "\n"))
        
        // Constraint maps
        private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
        private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
        private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
        private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
        
        // Constraints
        private var portraitConstraints = [NSLayoutConstraint]()
        private var landscapeConstraints = [NSLayoutConstraint]()
        
        init(\(elements.map( { "\($0.0): \($0.1)" } ).joined(separator: ", "))) {
    \(elements.map( { "\t\tself.\($0.0) = \($0.0)" } ).joined(separator: "\n"))

            doNotAutoResize(views: [\(elements.map( { $0.0 } ).joined(separator: ", "))])
            setTextToDefaults(labels: [])
            setButtonsToDefaults(buttons: [])
            
            // Portrait
            portraitSizeMap = [:
    \(elements.map( { "//\t\t\t\($0.0): (, )," } ).joined(separator: "\n"))
            ]
            
            portraitSpacingMap = [:
    \(elements.map( { "//\t\t\t\($0.0): (, )," } ).joined(separator: "\n"))
            ]
            
            // Landscape
            landscapeSizeMap = [:
    \(elements.map( { "//\t\t\t\($0.0): (, )," } ).joined(separator: "\n"))
            ]
            
            landscapeSpacingMap = [:
    \(elements.map( { "//\t\t\t\($0.0): (, )," } ).joined(separator: "\n"))
            ]
        }
        
        // MARK: Constraints
        
        func configureConstraints(view: UIView)  {
            let margins = view.layoutMarginsGuide
            view.backgroundColor = globalBackgroundColor()
            
            portraitConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: margins.heightAnchor, sizeMap: portraitSizeMap)
            portraitConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: margins.topAnchor, heightAnchor: margins.heightAnchor, spacingMap: portraitSpacingMap, parentView: view)
            
            landscapeConstraints += getSizeConstraints(widthAnchor: view.widthAnchor, heightAnchor: margins.heightAnchor, sizeMap: landscapeSizeMap)
            landscapeConstraints += getSpacingConstraints(leftAnchor: view.leftAnchor, widthAnchor: view.widthAnchor, topAnchor: margins.topAnchor, heightAnchor: margins.heightAnchor, spacingMap: landscapeSpacingMap, parentView: view)
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
    """)
}

