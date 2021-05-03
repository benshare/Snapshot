//
//  PopupOptionsView.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/8/21.
//

import Foundation
import UIKit

class PopupOptionsView: UIView {
    // MARK: Variables
    var buttons = [UIButton]()
    static let viewWidth: CGFloat = 100
    static let buttonRatio: CGFloat = 0.5
    private let mainColor: UIColor
    private let secondaryColor: UIColor
    
    // MARK: Initialization
    init(color: UIColor = .lightGray) {
        mainColor = color.darker()!
        secondaryColor = color
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(setButtonDefaults: Bool = false) {
        doNotAutoResize(views: [self] + buttons)
        self.widthAnchor.constraint(equalToConstant: PopupOptionsView.viewWidth).isActive = true
        if setButtonDefaults {
            setButtonsToDefaults(buttons: buttons, withInsets: 10)
        }
        
        var constraints = buttons.map( { $0.widthAnchor.constraint(equalTo: self.widthAnchor) })
        for i in 0...buttons.count - 1 {
            let button = buttons[i]
            constraints.append(button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: PopupOptionsView.buttonRatio))
            if i == 0 {
                constraints.append(button.topAnchor.constraint(equalTo: self.topAnchor))
            } else {
                constraints.append(button.topAnchor.constraint(equalTo: buttons[i - 1].bottomAnchor))
            }
            if i == buttons.count - 1 {
                constraints.append(button.bottomAnchor.constraint(equalTo: self.bottomAnchor))
            }
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: Customize
    func addButton(name: String, callback: @escaping () -> Void, isEnabled: Bool = true) {
        let button = UIButton()
        button.setTitle(name, for: .normal)
        button.addAction(callback)
        button.layer.borderWidth = 1
        if isEnabled {
            button.setTitleColor(mainColor, for: .normal)
            button.layer.borderColor = mainColor.cgColor
            button.backgroundColor = secondaryColor
        } else {
            button.setTitleColor(mainColor.lighter(), for: .normal)
            button.layer.borderColor = mainColor.lighter()?.cgColor
            button.backgroundColor = secondaryColor.lighter()
            button.isEnabled = false
        }
        
        buttons.append(button)
        addSubview(button)
    }
    
    func anchorToView(anchorView: UIView, superview: UIView) {
        // Default is to the right
        if superview.bounds.contains(anchorView.center.applying(CGAffineTransform(translationX: PopupOptionsView.viewWidth, y: 0))) {
            self.leftAnchor.constraint(equalTo: anchorView.centerXAnchor).isActive = true
            // Secondary default is down
            if superview.bounds.contains(anchorView.center.applying(CGAffineTransform(translationX: PopupOptionsView.viewWidth, y: PopupOptionsView.viewWidth * CGFloat(self.buttons.count) * PopupOptionsView.buttonRatio))) {
                self.topAnchor.constraint(equalTo: anchorView.centerYAnchor).isActive = true
                return
            }
            self.bottomAnchor.constraint(equalTo: anchorView.centerYAnchor).isActive = true
            return
        }
        // Same, but now on the left
        self.rightAnchor.constraint(equalTo: anchorView.centerXAnchor).isActive = true
        if superview.bounds.contains(anchorView.center.applying(CGAffineTransform(translationX: -PopupOptionsView.viewWidth, y: PopupOptionsView.viewWidth * CGFloat(self.buttons.count) * PopupOptionsView.buttonRatio))) {
            self.topAnchor.constraint(equalTo: anchorView.centerYAnchor).isActive = true
            return
        }
        self.bottomAnchor.constraint(equalTo: anchorView.centerYAnchor).isActive = true
    }
}
