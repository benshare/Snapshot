//
//  InformationButton.swift
//  Snapshot
//
//  Created by Benjamin Share on 3/16/21.
//

import Foundation
import UIKit

//class InformationButton: UIView

extension UIView {
    func addInformationButton(title: String, content: String, controller: UIViewController, image: UIImage = UIImage(named: "QuestionMark")!, buffer: CGFloat = 0) {
        let button = UIButton()
        doNotAutoResize(view: button)
        superview!.addSubview(button)
        button.setBackgroundImage(image, for: .normal)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20),
            button.leftAnchor.constraint(equalTo: rightAnchor, constant: buffer),
            button.bottomAnchor.constraint(equalTo: topAnchor, constant: -buffer),
        ])
        
        button.addAction {
            let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                action in
                alert.dismiss(animated: true, completion: nil)
            }))
            controller.present(alert, animated: true, completion: nil)
        }
    }
}
