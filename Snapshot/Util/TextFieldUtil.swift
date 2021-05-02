//
//  TextFieldUtil.swift
//  Snapshot
//
//  Created by Benjamin Share on 5/1/21.
//

import Foundation
import UIKit

extension UITextField {
    func addVisibilityIcon() {
        let showButton = UIButton()
        doNotAutoResize(view: showButton)
        addSubview(showButton)
        NSLayoutConstraint.activate([
            showButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            showButton.widthAnchor.constraint(equalTo: showButton.heightAnchor),
            showButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            showButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        showButton.setBackgroundImage(UIImage(named: "EyeIcon"), for: .normal)
        showButton.addAction {
            switch self.isSecureTextEntry {
            case true:
                self.isSecureTextEntry = false
                showButton.setBackgroundImage(UIImage(named: "EyeOffIcon"), for: .normal)
            case false:
                self.isSecureTextEntry = true
                showButton.setBackgroundImage(UIImage(named: "EyeIcon"), for: .normal)
            }
        }
    }
}
