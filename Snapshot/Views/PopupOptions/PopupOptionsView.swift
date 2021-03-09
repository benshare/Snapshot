//
//  PopupOptionsView.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/8/21.
//

import Foundation
import UIKit

class PopupOptionsView: UIView {
    var buttons = [UIButton]()
    static let viewWidth: CGFloat = 80
    static let buttonRatio: CGFloat = 0.4
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButton(name: String, callback: @escaping () -> Void, isEnabled: Bool = true) {
        let button = UIButton()
        button.setTitle(name, for: .normal)
        button.addAction(callback)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        if isEnabled {
            button.backgroundColor = .lightGray
            button.setTitleColor(.black, for: .normal)
        } else {
            button.backgroundColor = .white
            button.setTitleColor(.lightGray, for: .normal)
            button.isEnabled = false
        }
        
        buttons.append(button)
        addSubview(button)
    }
    
    func configureView(setButtonDefaults: Bool = false) {
        doNotAutoResize(views: [self] + buttons)
        self.widthAnchor.constraint(equalToConstant: PopupOptionsView.viewWidth).isActive = true
        if setButtonDefaults {
            setButtonsToDefaults(buttons: buttons)
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
}
