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
func doNotAutoResize(view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
}
func doNotAutoResize(views: [UIView]) {
    for view in views {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}

func setLabelsToDefaults(labels: [UILabel?]) {
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
    func addOverlappingSubview(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

// Debugging only
private func setTextBackgroundToRed(labels: [UILabel?]) {
    for label in labels {
        label?.backgroundColor = .red
    }
}

// MARK: Borders
enum BorderSide {
    case top, bottom, left, right
}

extension UIView {
    func addBorders(sides: [BorderSide], width: CGFloat = 2) {
        for side in sides {
            let border = UIView()
            doNotAutoResize(view: border)
            addSubview(border)
            switch side {
            case .top, .bottom:
                NSLayoutConstraint.activate([
                    border.widthAnchor.constraint(equalTo: widthAnchor),
                    border.heightAnchor.constraint(equalToConstant: width),
                    border.centerXAnchor.constraint(equalTo: centerXAnchor),
                ])
                switch side {
                case .top:
                    NSLayoutConstraint.activate([
                        border.topAnchor.constraint(equalTo: topAnchor)
                    ])
                case .bottom:
                    NSLayoutConstraint.activate([
                        border.bottomAnchor.constraint(equalTo: bottomAnchor)
                    ])
                default:
                    break
                }
            case .left, .right:
                NSLayoutConstraint.activate([
                    border.widthAnchor.constraint(equalToConstant: width),
                    border.heightAnchor.constraint(equalTo: heightAnchor),
                    border.centerYAnchor.constraint(equalTo: centerYAnchor),
                ])
                switch side {
                case .left:
                    NSLayoutConstraint.activate([
                        border.leftAnchor.constraint(equalTo: leftAnchor)
                    ])
                case .right:
                    NSLayoutConstraint.activate([
                        border.rightAnchor.constraint(equalTo: rightAnchor)
                    ])
                default:
                    break
                }
            }
            border.backgroundColor = .black
            border.accessibilityIdentifier = "Border"
        }
    }

    func removeBorders() {
        for subview in subviews {
            if subview.accessibilityIdentifier == "Border" {
                subview.removeFromSuperview()
            }
        }
    }
}

// MARK: UIImage
func addFrame(imageView: UIView, color: UIColor = .brown) {
    imageView.layer.cornerRadius = 5
    imageView.layer.borderWidth = 5
    imageView.layer.masksToBounds = true
    imageView.layer.borderColor = color.cgColor
}

func addIconToView(view: UIView, name: String, tint: UIColor? = nil) {
    let imageView = UIImageView()
    view.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor),
        imageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
    ])
    imageView.image = UIImage(named: name)?.withAlignmentRectInsets(UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20))
    imageView.contentMode = .scaleAspectFit
    if tint != nil {
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = tint
    }
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

// MARK: Stack Views
func getRowForCenteredView(view: UIView) -> UIView {
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

func getColumnForCenteredView(view: UIView, withBuffer: Int = 0) -> UIView {
    let column = UIView()
    doNotAutoResize(view: column)
    column.backgroundColor = .white
    column.addSubview(view)
    
    NSLayoutConstraint.activate([
        view.widthAnchor.constraint(equalTo: column.widthAnchor, constant: CGFloat(-withBuffer * 2)),
        view.centerXAnchor.constraint(equalTo: column.centerXAnchor),
        view.centerYAnchor.constraint(equalTo: column.centerYAnchor),
    ])
    return column
}

// MARK: Orientation
func orientationIsPortrait() -> Bool {
    return !UIDevice.current.orientation.isLandscape
}

// MARK: New Layouts
func generateNewLayout(name: String, elements: [(String, String)]) {
    print("""
    import UIKit

    class \(name)Layout: UILayout {
        // MARK: Properties
        
        // UI elements
    \(elements.map( { "\tprivate let \($0.0): \($0.1)" } ).joined(separator: "\n"))
        
        // Constraint maps
        private var portraitSizeMap: [UIView: (CGFloat, CGFloat)]!
        private var portraitSpacingMap: [UIView: (CGFloat, CGFloat)]!
        private var landscapeSizeMap: [UIView: (CGFloat, CGFloat)]!
        private var landscapeSpacingMap: [UIView: (CGFloat, CGFloat)]!
        
        // MARK: Initialization
        init(\(elements.map( { "\($0.0): \($0.1)" } ).joined(separator: ", "))) {
    \(elements.map( { "\t\tself.\($0.0) = \($0.0)" } ).joined(separator: "\n"))

            doNotAutoResize(views: [\(elements.map( { $0.0 } ).joined(separator: ", "))])
            setLabelsToDefaults(labels: [])
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
    }
    """)
}

